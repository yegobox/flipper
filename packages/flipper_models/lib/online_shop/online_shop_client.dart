import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:http/http.dart' as http;

/// A branch's public shop, as `GET /api/online-shop` returns it.
class OnlineShopSettings {
  const OnlineShopSettings({
    this.id,
    this.branchId,
    this.businessId,
    this.slug,
    this.enabled = false,
    this.displayName = '',
    this.description,
    this.logoUrl,
    this.contactPhone,
    this.whatsapp,
    this.showStock = false,
    this.pickup = true,
    this.delivery = false,
    this.deliveryNote,
    this.momoPayCode,
    this.momoNumber,
    this.airtelNumber,
  });

  final String? id;
  final String? branchId;
  final String? businessId;
  final String? slug;
  final bool enabled;
  final String displayName;
  final String? description;
  final String? logoUrl;
  final String? contactPhone;
  final String? whatsapp;
  final bool showStock;
  final bool pickup;
  final bool delivery;
  final String? deliveryNote;
  final String? momoPayCode;
  final String? momoNumber;
  final String? airtelNumber;

  /// Customers can pay by MoMo/Airtel, so the server will try to match SMS.
  bool get takesMobileMoney =>
      _has(momoPayCode) || _has(momoNumber) || _has(airtelNumber);

  factory OnlineShopSettings.fromJson(Map<String, dynamic> json) =>
      OnlineShopSettings(
        id: _str(json['id']),
        branchId: _str(json['branchId']),
        businessId: _str(json['businessId']),
        slug: _str(json['slug']),
        enabled: json['enabled'] == true,
        displayName: _str(json['displayName']) ?? '',
        description: _str(json['description']),
        logoUrl: _str(json['logoUrl']),
        contactPhone: _str(json['contactPhone']),
        whatsapp: _str(json['whatsapp']),
        showStock: json['showStock'] == true,
        pickup: json['pickup'] != false,
        delivery: json['delivery'] == true,
        deliveryNote: _str(json['deliveryNote']),
        momoPayCode: _str(json['momoPayCode']),
        momoNumber: _str(json['momoNumber']),
        airtelNumber: _str(json['airtelNumber']),
      );

  /// The `PUT /api/online-shop` body. Blank optional fields are sent as
  /// null so clearing a field clears it on the server; a blank slug is left
  /// out so the server derives one from the display name.
  Map<String, dynamic> toPutBody(String branchId) {
    String? clean(String? v) => _has(v) ? v!.trim() : null;
    return {
      'branchId': branchId,
      if (_has(slug)) 'slug': slug!.trim().toLowerCase(),
      'enabled': enabled,
      'displayName': displayName.trim(),
      'description': clean(description),
      'logoUrl': clean(logoUrl),
      'contactPhone': clean(contactPhone),
      'whatsapp': clean(whatsapp),
      'showStock': showStock,
      'pickup': pickup,
      'delivery': delivery,
      'deliveryNote': clean(deliveryNote),
      'momoPayCode': clean(momoPayCode),
      'momoNumber': clean(momoNumber),
      'airtelNumber': clean(airtelNumber),
    };
  }
}

/// `GET`/`PUT /api/online-shop` response.
class OnlineShopState {
  const OnlineShopState({
    this.shop,
    this.hiddenVariantIds = const {},
    this.url,
    this.smsBridgePaired = false,
  });

  /// Null until the shop is first saved.
  final OnlineShopSettings? shop;
  final Set<String> hiddenVariantIds;
  final String? url;
  final bool smsBridgePaired;

  factory OnlineShopState.fromJson(Map<String, dynamic> json) {
    final shop = json['shop'];
    return OnlineShopState(
      shop: shop is Map
          ? OnlineShopSettings.fromJson(Map<String, dynamic>.from(shop))
          : null,
      hiddenVariantIds: _idSet(json['hiddenVariantIds']),
      url: _str(json['url']),
      smsBridgePaired: json['smsBridgePaired'] == true,
    );
  }

  OnlineShopState copyWith({Set<String>? hiddenVariantIds}) => OnlineShopState(
    shop: shop,
    hiddenVariantIds: hiddenVariantIds ?? this.hiddenVariantIds,
    url: url,
    smsBridgePaired: smsBridgePaired,
  );
}

/// Slug rule the server enforces: lowercase a-z, 0-9 and '-', 3 to 48 chars.
final RegExp kOnlineShopSlugPattern = RegExp(r'^[a-z0-9-]{3,48}$');

bool isValidOnlineShopSlug(String slug) =>
    kOnlineShopSlugPattern.hasMatch(slug);

/// A best-effort slug from a shop name, for the live preview before the
/// first save (the server derives the real one).
String suggestOnlineShopSlug(String name) {
  final slug = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.length > 48 ? slug.substring(0, 48) : slug;
}

class OnlineShopException implements Exception {
  const OnlineShopException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;

  /// The server's `error` field, e.g. `slug_taken`.
  final String? code;

  bool get slugTaken => code == 'slug_taken';
  bool get conflict => statusCode == 409;

  @override
  String toString() => message;
}

/// Client for the connector's online-shop staff routes
/// (`data-connector/src/api/online_shop.rs`). Authenticated with this
/// device's connector token, like every other [DataConnectorClient] call.
class OnlineShopClient {
  OnlineShopClient({
    required Future<String> Function() baseUrl,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 20),
  }) : _baseUrl = baseUrl,
       _http = httpClient,
       _timeout = timeout;

  final Future<String> Function() _baseUrl;
  final http.Client? _http;
  final Duration _timeout;

  Future<OnlineShopState> load(String branchId) async {
    final body = await _send(
      (client, base) => client.get(
        Uri.parse(
          '${base}api/online-shop',
        ).replace(queryParameters: {'branch_id': branchId}),
      ),
    );
    return OnlineShopState.fromJson(body);
  }

  Future<OnlineShopState> save(
    String branchId,
    OnlineShopSettings settings,
  ) async {
    final body = await _send(
      (client, base) => client.put(
        Uri.parse('${base}api/online-shop'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(settings.toPutBody(branchId)),
      ),
    );
    return OnlineShopState.fromJson(body);
  }

  /// Hides (or shows again) variants on the public shop. Returns the full
  /// hidden set after the change.
  Future<Set<String>> setHidden({
    required String branchId,
    required List<String> variantIds,
    required bool hidden,
  }) async {
    final body = await _send(
      (client, base) => client.put(
        Uri.parse('${base}api/online-shop/hidden'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'branchId': branchId,
          'variantIds': variantIds,
          'hidden': hidden,
        }),
      ),
    );
    return _idSet(body['hiddenVariantIds']);
  }

  /// Moves an order along. The server answers with the updated order and
  /// mirrors it to Ditto, so the list also updates on its own.
  Future<OnlineOrder> updateOrder({
    required String branchId,
    required String orderId,
    required OnlineOrderAction action,
    String? ticketTransactionId,
    String? smsId,
  }) async {
    final body = await _send(
      (client, base) => client.patch(
        Uri.parse('${base}api/online-orders/${Uri.encodeComponent(orderId)}'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'branchId': branchId,
          'action': action.wire,
          if (ticketTransactionId != null)
            'ticketTransactionId': ticketTransactionId,
          if (smsId != null) 'smsId': smsId,
        }),
      ),
    );
    return OnlineOrder.fromDitto(body);
  }

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function(http.Client client, String base) call,
  ) async {
    final raw = await _baseUrl();
    final base = raw.endsWith('/') ? raw : '$raw/';
    final client = DataConnectorClient(baseUrl: base, inner: _http);
    final http.Response response;
    try {
      response = await call(client, base).timeout(_timeout);
    } on TimeoutException {
      throw const OnlineShopException(
        'The server took too long to answer. Check the connection and try again.',
      );
    } on http.ClientException {
      throw const OnlineShopException(
        'Could not reach the server. Check the connection and try again.',
      );
    } finally {
      client.close();
    }
    final body = decodeJsonObject(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = body?['error'];
      final code = error is String && error.isNotEmpty ? error : null;
      throw OnlineShopException(
        code ?? 'Request failed (${response.statusCode})',
        statusCode: response.statusCode,
        code: code,
      );
    }
    return body ?? const {};
  }
}

bool _has(String? v) => v != null && v.trim().isNotEmpty;

String? _str(Object? v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

Set<String> _idSet(Object? v) => v is List
    ? {
        for (final id in v)
          if (id != null && id.toString().isNotEmpty) id.toString(),
      }
    : <String>{};
