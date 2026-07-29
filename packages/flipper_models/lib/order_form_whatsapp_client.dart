import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_models/data_connector_http_log.dart';
import 'package:http/http.dart' as http;

/// WhatsApp delivery backends supported by data-connector.
abstract final class WhatsAppProvider {
  static const openwa = 'openwa';
  static const meta = 'meta';
}

/// Sends text / PDF via data-connector WhatsApp routes.
///
/// Pass [provider] per call (or [defaultProvider]) to switch OpenWA vs Meta.
/// Meta outside the 24h window returns [OrderFormWhatsAppSendResult.needsOptIn]
/// with [chatUrl] / [qrPngBase64] while the message is queued server-side.
class OrderFormWhatsAppClient {
  OrderFormWhatsAppClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.logHttp = true,
    this.defaultProvider,
  }) : _http = httpClient ?? http.Client(),
       _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final String baseUrl;
  final http.Client _http;
  final String _base;
  final bool logHttp;
  final String? defaultProvider;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Future<OrderFormWhatsAppSendResult> sendText({
    required String phone,
    required String text,
    String? provider,
  }) async {
    final uri = Uri.parse('${_base}api/whatsapp/send-text');
    final body = <String, dynamic>{
      'phone': phone,
      'text': text,
      if (_effectiveProvider(provider) != null)
        'provider': _effectiveProvider(provider),
    };
    return _post(
      uri: uri,
      body: body,
      logBody:
          '{"phone":"$phone","text":"…","provider":"${_effectiveProvider(provider) ?? ""}"}',
      operation: 'WhatsApp send-text',
    );
  }

  Future<OrderFormWhatsAppSendResult> sendDocument({
    required String phone,
    required Uint8List pdfBytes,
    required String filename,
    String? caption,
    String? provider,
  }) async {
    final uri = Uri.parse('${_base}api/whatsapp/send-document');
    final body = <String, dynamic>{
      'phone': phone,
      'pdf_base64': base64Encode(pdfBytes),
      'filename': filename,
      if (caption != null && caption.trim().isNotEmpty)
        'caption': caption.trim(),
      if (_effectiveProvider(provider) != null)
        'provider': _effectiveProvider(provider),
    };
    return _post(
      uri: uri,
      body: body,
      logBody:
          '{"phone":"$phone","filename":"$filename","provider":"${_effectiveProvider(provider) ?? ""}","pdf_base64":"…"}',
      operation: 'WhatsApp send-document',
    );
  }

  String? _effectiveProvider(String? perCall) {
    final raw = (perCall ?? defaultProvider)?.trim();
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }

  Future<OrderFormWhatsAppSendResult> _post({
    required Uri uri,
    required Map<String, dynamic> body,
    required String logBody,
    required String operation,
  }) async {
    final encodedBody = jsonEncode(body);

    if (logHttp) {
      DataConnectorHttpLog.request(
        method: 'POST',
        uri: uri,
        body: logBody,
        operation: operation,
      );
    }

    final started = Stopwatch()..start();
    final response = await _http.post(
      uri,
      headers: _jsonHeaders,
      body: encodedBody,
    );
    started.stop();

    if (logHttp) {
      DataConnectorHttpLog.response(
        method: 'POST',
        uri: uri,
        statusCode: response.statusCode,
        body: response.body,
        elapsed: started.elapsed,
        operation: operation,
      );
    }

    Map<String, dynamic>? decodedMap;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        decodedMap = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decodedMap != null) {
        return OrderFormWhatsAppSendResult.fromJson(decodedMap);
      }
      return const OrderFormWhatsAppSendResult(ok: true);
    }

    // Meta 24h window closed: message queued; show QR / wa.me to the customer.
    if (response.statusCode == 409 &&
        decodedMap != null &&
        decodedMap['needs_opt_in'] == true) {
      return OrderFormWhatsAppSendResult.fromJson(decodedMap);
    }

    String message = 'WhatsApp send failed (${response.statusCode})';
    if (decodedMap != null && decodedMap['error'] != null) {
      message = decodedMap['error'].toString();
    }
    throw OrderFormWhatsAppException(message);
  }
}

class OrderFormWhatsAppSendResult {
  const OrderFormWhatsAppSendResult({
    required this.ok,
    this.messageId,
    this.provider,
    this.mediaId,
    this.needsOptIn = false,
    this.queued = false,
    this.queueId,
    this.chatUrl,
    this.qrPngBase64,
    this.error,
  });

  factory OrderFormWhatsAppSendResult.fromJson(Map<String, dynamic> json) {
    return OrderFormWhatsAppSendResult(
      ok: json['ok'] == true,
      messageId:
          json['message_id']?.toString() ?? json['messageId']?.toString(),
      provider: json['provider']?.toString(),
      mediaId: json['media_id']?.toString() ?? json['mediaId']?.toString(),
      needsOptIn: json['needs_opt_in'] == true || json['needsOptIn'] == true,
      queued: json['queued'] == true,
      queueId: json['queue_id']?.toString() ?? json['queueId']?.toString(),
      chatUrl: json['chat_url']?.toString() ?? json['chatUrl']?.toString(),
      qrPngBase64:
          json['qr_png_base64']?.toString() ?? json['qrPngBase64']?.toString(),
      error: json['error']?.toString(),
    );
  }

  final bool ok;
  final String? messageId;
  final String? provider;
  final String? mediaId;
  final bool needsOptIn;
  final bool queued;
  final String? queueId;
  final String? chatUrl;
  final String? qrPngBase64;
  final String? error;
}

class OrderFormWhatsAppException implements Exception {
  OrderFormWhatsAppException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Creates a WhatsApp client aimed at data-connector routes.
Future<OrderFormWhatsAppClient> createOrderFormWhatsAppClient({
  required String dataConnectorUrl,
  String? defaultProvider,
}) async {
  final trimmed = dataConnectorUrl.trim();
  if (trimmed.isEmpty) {
    throw OrderFormWhatsAppException(
      'Ebm.dataConnectorUrl is required for WhatsApp (do not use taxServerUrl)',
    );
  }
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  return OrderFormWhatsAppClient(
    baseUrl: base,
    defaultProvider: defaultProvider,
  );
}
