import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/bulk_rra_client.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

import '../models/flo_models.dart';

class FloChatException implements Exception {
  FloChatException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// HTTP client for data-connector Flo AI endpoints.
class FloChatService {
  FloChatService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> _baseUrl() async {
    final branchId = ProxyService.box.getBranchId();
    String? dataConnectorUrl;
    if (branchId != null) {
      try {
        final ebm = await ProxyService.getStrategy(Strategy.capella)
            .ebm(branchId: branchId, fetchRemote: false);
        dataConnectorUrl = ebm?.dataConnectorUrl;
      } catch (_) {}
    }
    if (dataConnectorUrl != null && dataConnectorUrl.trim().isNotEmpty) {
      return resolveDataConnectorBaseUrl(dataConnectorUrl: dataConnectorUrl);
    }
    if (kDebugMode) {
      return 'http://127.0.0.1:8084/';
    }
    return 'https://data-connector.yegobox.com/';
  }

  Future<FloChatResponse> chat({
    required String branchId,
    required String message,
    List<Map<String, String>> history = const [],
    String mode = 'business',
    String? conversationId,
    Map<String, dynamic>? deviceSales,
    String? shopName,
  }) async {
    final base = await _baseUrl();
    final uri = Uri.parse('${base}api/ai/chat');
    http.Response response;
    try {
      response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'branch_id': branchId,
          'message': message,
          'history': history,
          'mode': mode,
          if (conversationId != null) 'conversation_id': conversationId,
          if (deviceSales != null) 'device_sales': deviceSales,
          if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
        }),
      );
    } catch (e) {
      throw FloChatException('Could not reach Flo at $base: $e');
    }
    if (response.statusCode != 200) {
      throw FloChatException(_errorMessage(response));
    }
    return FloChatResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Stream<FloChatEvent> streamChat({
    required String branchId,
    required String message,
    List<Map<String, String>> history = const [],
    String mode = 'business',
    String? conversationId,
    Map<String, dynamic>? deviceSales,
    String? shopName,
  }) async* {
    final base = await _baseUrl();
    final uri = Uri.parse('${base}api/ai/chat/stream');
    final request = http.Request('POST', uri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'text/event-stream';
    request.body = jsonEncode({
      'branch_id': branchId,
      'message': message,
      'history': history,
      'mode': mode,
      if (conversationId != null) 'conversation_id': conversationId,
      if (deviceSales != null) 'device_sales': deviceSales,
      if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
    });

    http.StreamedResponse streamed;
    try {
      streamed = await _client.send(request);
    } catch (e) {
      throw FloChatException('Could not reach Flo at $base: $e');
    }
    if (streamed.statusCode != 200) {
      final body = await streamed.stream.bytesToString();
      throw FloChatException(
        _errorMessage(http.Response(body, streamed.statusCode)),
      );
    }

    var currentEvent = 'message';
    var lineBuffer = '';
    await for (final chunk in streamed.stream.transform(utf8.decoder)) {
      lineBuffer += chunk;
      final lines = lineBuffer.split('\n');
      lineBuffer = lines.removeLast();
      for (final line in lines) {
        if (line.startsWith('event:')) {
          currentEvent = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          yield FloChatEvent(
            event: currentEvent,
            data: line.substring(5).trim(),
          );
        }
      }
    }
  }

  Future<FloWhatsAppDraft> requestDraft({
    required String branchId,
    required String customerMessage,
    String? threadContext,
  }) async {
    final base = await _baseUrl();
    final uri = Uri.parse('${base}api/ai/whatsapp/draft');
    http.Response response;
    try {
      response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'branch_id': branchId,
          'customer_message': customerMessage,
          if (threadContext != null) 'thread_context': threadContext,
        }),
      );
    } catch (e) {
      throw FloChatException('Could not reach Flo draft API: $e');
    }
    if (response.statusCode != 200) {
      throw FloChatException(_errorMessage(response));
    }
    return FloWhatsAppDraft.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<FloDailyBriefing> fetchDailyBriefing({
    required String branchId,
  }) async {
    final base = await _baseUrl();
    final uri = Uri.parse('${base}api/ai/briefing').replace(
      queryParameters: {'branch_id': branchId},
    );
    http.Response response;
    try {
      response = await _client.get(uri);
    } catch (e) {
      throw FloChatException('Could not reach Flo briefing at $base: $e');
    }
    if (response.statusCode != 200) {
      throw FloChatException(_errorMessage(response));
    }
    return FloDailyBriefing.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  String _errorMessage(http.Response response) {
    var message = 'Flo request failed (${response.statusCode})';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = (body['error'] as String?) ?? message;
    } catch (_) {}
    return message;
  }
}
