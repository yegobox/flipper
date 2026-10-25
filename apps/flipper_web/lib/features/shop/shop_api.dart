import 'dart:async';
import 'dart:convert';

import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// The connector the public shop talks to. Same host as Books' connector
/// calls; `--dart-define=SHOP_API_BASE_URL=...` points a build elsewhere.
String shopApiBaseUrl() {
  const configured = String.fromEnvironment('SHOP_API_BASE_URL');
  if (configured.isNotEmpty) return configured;
  return kDebugMode
      ? 'http://localhost:8084'
      : 'https://data-connector.yegobox.com';
}

/// Where the order link's secret goes, rather than the URL: query strings
/// end up in access logs.
const String kShopOrderTokenHeader = 'X-Order-Token';

class ShopApiException implements Exception {
  const ShopApiException(
    this.statusCode, {
    this.code,
    this.variantIds = const [],
  });

  /// 0 when the request never got an answer (offline, timeout).
  final int statusCode;

  /// The server's `error` field: `item_unavailable`, or a plain message
  /// (`data-connector/src/api/online_shop.rs`).
  final String? code;

  /// For `item_unavailable`: the lines the shop can no longer sell.
  final List<String> variantIds;

  bool get notFound => statusCode == 404;
  bool get itemUnavailable => code == 'item_unavailable';
  bool get rateLimited => statusCode == 429;
  bool get offline => statusCode == 0;

  /// The body was over the server's size cap.
  bool get tooLarge => statusCode == 413;

  /// The cap on open unpaid orders: 3 per phone, 10 per connection, per
  /// shop. Also a 429, so check it before [rateLimited].
  bool get tooManyOpen => rateLimited && (code ?? '').contains('unpaid');

  /// The shop has no free amount to ask for right now.
  bool get busy => statusCode == 503;

  /// The server refused what was sent (e.g. a fraction of a counted item).
  bool get invalid => statusCode == 400;

  /// A checkout placed long enough ago that the server no longer hands its
  /// link back.
  bool get alreadyPlaced => statusCode == 409 && !itemUnavailable;

  @override
  String toString() => 'ShopApiException($statusCode, $code)';
}

/// One line of a new order.
class ShopOrderRequestLine {
  const ShopOrderRequestLine({required this.variantId, required this.qty});

  final String variantId;
  final double qty;

  Map<String, dynamic> toJson() => {
    'variantId': variantId,
    // Whole units go as ints so the server never sees `2.0`.
    'qty': qty == qty.roundToDouble() ? qty.toInt() : qty,
  };
}

class ShopOrderRequest {
  const ShopOrderRequest({
    required this.customerName,
    required this.customerPhone,
    required this.fulfilment,
    required this.items,
    required this.idempotencyKey,
    this.deliveryAddress,
    this.note,
    this.payerPhone,
  });

  final String customerName;
  final String customerPhone;
  final String fulfilment;
  final String? deliveryAddress;
  final String? note;
  final String? payerPhone;
  final List<ShopOrderRequestLine> items;

  /// Same key on a retry, so a double tap or a lost response cannot place
  /// the order twice. Not the order link's secret: the server makes that and
  /// returns it as [ShopOrderView.token].
  final String idempotencyKey;

  Map<String, dynamic> toJson() {
    String? clean(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    return {
      'customerName': customerName.trim(),
      'customerPhone': customerPhone.trim(),
      'fulfilment': fulfilment,
      if (clean(deliveryAddress) != null)
        'deliveryAddress': clean(deliveryAddress),
      if (clean(note) != null) 'note': clean(note),
      if (clean(payerPhone) != null) 'payerPhone': clean(payerPhone),
      'items': [for (final l in items) l.toJson()],
      'idempotencyKey': idempotencyKey,
    };
  }
}

/// Client for the connector's public shop routes. Sends no auth header at
/// all: these routes are for anyone with the link.
class ShopApi {
  ShopApi({
    String? baseUrl,
    http.Client? client,
    Duration timeout = const Duration(seconds: 20),
  }) : _base = _normalize(baseUrl ?? shopApiBaseUrl()),
       _client = client ?? http.Client(),
       _timeout = timeout;

  final String _base;
  final http.Client _client;
  final Duration _timeout;

  static String _normalize(String base) => base.endsWith('/') ? base : '$base/';

  String _path(String slug) => 'api/shop/${Uri.encodeComponent(slug)}';

  Future<ShopCatalog> catalog(String slug) async =>
      ShopCatalog.fromJson(await _send('GET', _path(slug)));

  Future<ShopOrderView> placeOrder(
    String slug,
    ShopOrderRequest request,
  ) async => ShopOrderView.fromJson(
    await _send('POST', '${_path(slug)}/orders', body: request.toJson()),
  );

  /// The order behind a link. [token] is the secret the create call
  /// returned; it goes in a header, not the URL.
  Future<ShopOrderView> order(String slug, String id, String token) async =>
      ShopOrderView.fromJson(
        await _send(
          'GET',
          '${_path(slug)}/orders/${Uri.encodeComponent(id)}',
          token: token,
        ),
      );

  /// "I paid, here is the MoMo transaction id": for staff to check when the
  /// SMS match was not certain.
  Future<ShopOrderView> claimPayment(
    String slug,
    String id, {
    required String token,
    required String transactionId,
  }) async => ShopOrderView.fromJson(
    await _send(
      'POST',
      '${_path(slug)}/orders/${Uri.encodeComponent(id)}/payment',
      body: {'transactionId': transactionId.trim()},
      token: token,
    ),
  );

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final request = http.Request(method, Uri.parse('$_base$path'));
    if (token != null) request.headers[kShopOrderTokenHeader] = token;
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    final http.Response response;
    try {
      response = await http.Response.fromStream(
        await _client.send(request).timeout(_timeout),
      );
    } on TimeoutException {
      throw const ShopApiException(0, code: 'timeout');
    } on http.ClientException {
      throw const ShopApiException(0, code: 'offline');
    }
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) json = Map<String, dynamic>.from(decoded);
    } catch (_) {
      json = null;
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final ids = json?['variantIds'];
      throw ShopApiException(
        response.statusCode,
        code: json?['error'] is String ? json!['error'] as String : null,
        variantIds: ids is List ? [for (final i in ids) '$i'] : const [],
      );
    }
    return json ?? const {};
  }
}
