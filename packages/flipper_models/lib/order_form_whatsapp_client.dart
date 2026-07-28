import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_models/data_connector_http_log.dart';
import 'package:http/http.dart' as http;

/// Sends an order-form PDF to a stock handover staff member via WhatsApp
/// (data-connector → OpenWA at whatsapp.yegobox.com).
class OrderFormWhatsAppClient {
  OrderFormWhatsAppClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.logHttp = true,
  }) : _http = httpClient ?? http.Client(),
       _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final String baseUrl;
  final http.Client _http;
  final String _base;
  final bool logHttp;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Future<OrderFormWhatsAppSendResult> sendText({
    required String phone,
    required String text,
  }) async {
    final uri = Uri.parse('${_base}api/whatsapp/send-text');
    final body = <String, dynamic>{'phone': phone, 'text': text};
    return _post(
      uri: uri,
      body: body,
      logBody: '{"phone":"$phone","text":"…"}',
      operation: 'WhatsApp send-text',
    );
  }

  Future<OrderFormWhatsAppSendResult> sendDocument({
    required String phone,
    required Uint8List pdfBytes,
    required String filename,
    String? caption,
  }) async {
    final uri = Uri.parse('${_base}api/whatsapp/send-document');
    final body = <String, dynamic>{
      'phone': phone,
      'pdf_base64': base64Encode(pdfBytes),
      'filename': filename,
      if (caption != null && caption.trim().isNotEmpty)
        'caption': caption.trim(),
    };
    return _post(
      uri: uri,
      body: body,
      logBody: '{"phone":"$phone","filename":"$filename","pdf_base64":"…"}',
      operation: 'WhatsApp send-document',
    );
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        return OrderFormWhatsAppSendResult(
          ok: decoded['ok'] == true,
          messageId:
              decoded['message_id']?.toString() ??
              decoded['messageId']?.toString(),
        );
      }
      return const OrderFormWhatsAppSendResult(ok: true);
    }

    String message = 'WhatsApp send failed (${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] != null) {
        message = decoded['error'].toString();
      }
    } catch (_) {}
    throw OrderFormWhatsAppException(message);
  }
}

class OrderFormWhatsAppSendResult {
  const OrderFormWhatsAppSendResult({required this.ok, this.messageId});

  final bool ok;
  final String? messageId;
}

class OrderFormWhatsAppException implements Exception {
  OrderFormWhatsAppException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Creates a WhatsApp client aimed at data-connector OpenWA routes.
///
/// [dataConnectorUrl] must be [Ebm.dataConnectorUrl] (not [Ebm.taxServerUrl]).
Future<OrderFormWhatsAppClient> createOrderFormWhatsAppClient({
  required String dataConnectorUrl,
}) async {
  final trimmed = dataConnectorUrl.trim();
  if (trimmed.isEmpty) {
    throw OrderFormWhatsAppException(
      'Ebm.dataConnectorUrl is required for WhatsApp (do not use taxServerUrl)',
    );
  }
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  return OrderFormWhatsAppClient(baseUrl: base);
}
