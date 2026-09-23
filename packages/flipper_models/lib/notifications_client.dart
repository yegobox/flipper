import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_models/data_connector_client.dart';
import 'package:flipper_models/data_connector_http_log.dart';
import 'package:http/http.dart' as http;

/// Email and SMS through data-connector's `/api/notify/*` routes.
///
/// The transport lives on the server so credits are charged somewhere a device
/// cannot skip, and so the booking wording can change without shipping an app
/// release. Mirrors [OrderFormWhatsAppClient] deliberately — same base-URL
/// resolution, same logging, same failure shape.
class NotificationsClient {
  NotificationsClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.logHttp = true,
  }) : _http = httpClient ?? DataConnectorClient(baseUrl: baseUrl),
       _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final String baseUrl;
  final http.Client _http;
  final String _base;
  final bool logHttp;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  /// Sends one email, optionally with attachments (the quotation PDF).
  Future<NotifyEmailResult> sendEmail({
    required List<String> to,
    required String subject,
    required String htmlBody,
    String? plainText,
    List<String> cc = const [],
    List<String> bcc = const [],
    String? replyTo,
    List<NotifyAttachment> attachments = const [],
    String? branchId,
    String? idempotencyKey,
  }) async {
    final body = <String, dynamic>{
      'to': to,
      if (cc.isNotEmpty) 'cc': cc,
      if (bcc.isNotEmpty) 'bcc': bcc,
      'subject': subject,
      'html_body': htmlBody,
      if (plainText != null && plainText.isNotEmpty) 'plain_text': plainText,
      if (replyTo != null && replyTo.trim().isNotEmpty) 'reply_to': replyTo,
      if (attachments.isNotEmpty)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (branchId != null) 'branch_id': branchId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
    };

    final decoded = await _post(
      uri: Uri.parse('${_base}api/notify/email'),
      body: body,
      // Never log the recipient in full or the base64 payload.
      logBody:
          '{"to":["${_redactEmails(to)}"],"subject":"$subject",'
          '"attachments":${attachments.length},"html_body":"…"}',
      operation: 'notify email',
    );
    return NotifyEmailResult.fromJson(decoded);
  }

  /// Sends one SMS to each recipient. Costs credits; the server charges them.
  Future<NotifySmsResult> sendSms({
    required List<String> to,
    required String text,
    required String branchId,
    String? idempotencyKey,
  }) async {
    final decoded = await _post(
      uri: Uri.parse('${_base}api/notify/sms'),
      body: <String, dynamic>{
        'to': to,
        'text': text,
        'branch_id': branchId,
        if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      },
      logBody:
          '{"to":["${_redactPhones(to)}"],"branch_id":"$branchId","text":"…"}',
      operation: 'notify sms',
    );
    return NotifySmsResult.fromJson(decoded);
  }

  /// Booking confirmation — the server renders the copy and fans out to both
  /// channels, so the wording is not pinned to an app version.
  Future<BookingConfirmationResult> sendBookingConfirmation(
    BookingConfirmationPayload payload,
  ) async {
    final decoded = await _post(
      uri: Uri.parse('${_base}api/notify/booking-confirmation'),
      body: payload.toJson(),
      logBody:
          '{"event":"${payload.event}","branch_id":"${payload.branchId}",'
          '"stay_id":"${payload.stayId}","guest":"…"}',
      operation: 'notify booking-confirmation',
    );
    return BookingConfirmationResult.fromJson(decoded);
  }

  Future<Map<String, dynamic>> _post({
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
        // Not response.body: these routes echo the recipient back — a
        // `results` array of phone numbers, or the address a confirmation
        // went to — and the request log above goes to the trouble of
        // redacting exactly those.
        body: _redactedResponseBody(response.body),
        elapsed: started.elapsed,
        operation: operation,
      );
    }

    Map<String, dynamic> decodedMap = const {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        decodedMap = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedMap;
    }

    final message =
        decodedMap['error']?.toString() ?? '$operation failed '
            '(${response.statusCode})';

    // Distinct type: out of credits is the one failure the desk can act on.
    if (response.statusCode == 402) {
      throw NotifyInsufficientCreditsException(message);
    }
    throw NotifyException(message);
  }

  void close() => _http.close();
}

/// A file to attach. Base64 encoding happens at the edge so callers pass bytes.
class NotifyAttachment {
  const NotifyAttachment({
    required this.name,
    required this.bytes,
    this.contentType = 'application/pdf',
  });

  final String name;
  final Uint8List bytes;
  final String contentType;

  Map<String, dynamic> toJson() => {
    'name': name,
    'content_type': contentType,
    'base64': base64Encode(bytes),
  };
}

class NotifyEmailResult {
  const NotifyEmailResult({
    required this.ok,
    this.deduplicated = false,
    this.operationId,
  });

  factory NotifyEmailResult.fromJson(Map<String, dynamic> json) =>
      NotifyEmailResult(
        ok: json['ok'] == true,
        deduplicated: json['deduplicated'] == true,
        operationId: json['operation_id']?.toString(),
      );

  final bool ok;
  final bool deduplicated;
  final String? operationId;
}

class NotifySmsRecipientResult {
  const NotifySmsRecipientResult({
    required this.to,
    required this.status,
    this.error,
  });

  factory NotifySmsRecipientResult.fromJson(Map<String, dynamic> json) =>
      NotifySmsRecipientResult(
        to: json['to']?.toString() ?? '',
        status: json['status']?.toString() ?? 'failed',
        error: json['error']?.toString(),
      );

  final String to;

  /// `sent` | `failed` | `invalid_number` | `insufficient_credits`
  final String status;
  final String? error;

  bool get sent => status == 'sent';
}

class NotifySmsResult {
  const NotifySmsResult({
    required this.ok,
    this.deduplicated = false,
    this.creditsCharged = 0,
    this.creditsRemaining,
    this.results = const [],
  });

  factory NotifySmsResult.fromJson(Map<String, dynamic> json) => NotifySmsResult(
    ok: json['ok'] == true,
    deduplicated: json['deduplicated'] == true,
    creditsCharged: (json['credits_charged'] as num?)?.toInt() ?? 0,
    creditsRemaining: (json['credits_remaining'] as num?)?.toDouble(),
    results: (json['results'] as List?)
            ?.whereType<Map>()
            .map((r) =>
                NotifySmsRecipientResult.fromJson(Map<String, dynamic>.from(r)))
            .toList() ??
        const [],
  );

  final bool ok;
  final bool deduplicated;
  final int creditsCharged;
  final double? creditsRemaining;
  final List<NotifySmsRecipientResult> results;
}

/// One channel's outcome on a booking confirmation.
class NotifyLegResult {
  const NotifyLegResult({
    required this.attempted,
    required this.status,
    this.to,
    this.reason,
    this.error,
  });

  factory NotifyLegResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NotifyLegResult(attempted: false, status: 'skipped');
    }
    return NotifyLegResult(
      attempted: json['attempted'] == true,
      status: json['status']?.toString() ?? 'skipped',
      to: json['to']?.toString(),
      reason: json['reason']?.toString(),
      error: json['error']?.toString(),
    );
  }

  final bool attempted;

  /// `sent` | `failed` | `skipped` | `invalid_number` | `insufficient_credits`
  final String status;
  final String? to;

  /// Why it was skipped: `no_phone`, `no_email`, `disabled`.
  final String? reason;
  final String? error;

  bool get sent => status == 'sent';
  bool get outOfCredits => status == 'insufficient_credits';
}

class BookingConfirmationResult {
  const BookingConfirmationResult({
    required this.ok,
    this.deduplicated = false,
    this.sms = const NotifyLegResult(attempted: false, status: 'skipped'),
    this.email = const NotifyLegResult(attempted: false, status: 'skipped'),
  });

  factory BookingConfirmationResult.fromJson(Map<String, dynamic> json) =>
      BookingConfirmationResult(
        ok: json['ok'] == true,
        deduplicated: json['deduplicated'] == true,
        sms: NotifyLegResult.fromJson(
          (json['sms'] as Map?)?.cast<String, dynamic>(),
        ),
        email: NotifyLegResult.fromJson(
          (json['email'] as Map?)?.cast<String, dynamic>(),
        ),
      );

  final bool ok;
  final bool deduplicated;
  final NotifyLegResult sms;
  final NotifyLegResult email;

  bool get anySent => sms.sent || email.sent;
  bool get outOfCredits => sms.outOfCredits;
}

class BookingConfirmationPayload {
  const BookingConfirmationPayload({
    required this.event,
    required this.branchId,
    required this.stayId,
    required this.guestName,
    required this.roomName,
    required this.checkInAt,
    required this.checkOutAt,
    required this.nights,
    this.reference,
    this.guestPhone,
    this.guestEmail,
    this.adults = 1,
    this.children = 0,
    this.nightlyRate = 0,
    this.currency = 'RWF',
    this.businessName,
    this.branchName,
    this.branchPhone,
    this.checkOutHour = 11,
    this.sendSms = true,
    this.sendEmail = true,
    this.idempotencyKey,
  });

  /// `reserved` | `checked_in`
  final String event;
  final String branchId;
  final String stayId;
  final String? reference;
  final String guestName;
  final String? guestPhone;
  final String? guestEmail;
  final String roomName;
  final DateTime checkInAt;
  final DateTime checkOutAt;
  final int nights;
  final int adults;
  final int children;
  final double nightlyRate;
  final String currency;
  final String? businessName;
  final String? branchName;
  final String? branchPhone;
  final int checkOutHour;
  final bool sendSms;
  final bool sendEmail;
  final String? idempotencyKey;

  Map<String, dynamic> toJson() => {
    'event': event,
    'branch_id': branchId,
    'stay_id': stayId,
    if (reference != null) 'reference': reference,
    'guest_name': guestName,
    if (guestPhone != null) 'guest_phone': guestPhone,
    if (guestEmail != null) 'guest_email': guestEmail,
    'room_name': roomName,
    'check_in_at': checkInAt.toUtc().toIso8601String(),
    'check_out_at': checkOutAt.toUtc().toIso8601String(),
    'nights': nights,
    'adults': adults,
    'children': children,
    'nightly_rate': nightlyRate,
    'currency': currency,
    if (businessName != null) 'business_name': businessName,
    if (branchName != null) 'branch_name': branchName,
    if (branchPhone != null) 'branch_phone': branchPhone,
    'check_out_hour': checkOutHour,
    'send_sms': sendSms,
    'send_email': sendEmail,
    if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
  };
}

class NotifyException implements Exception {
  NotifyException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// The branch has no credits left. Worth its own type: it is the one send
/// failure a clerk can do something about.
class NotifyInsufficientCreditsException extends NotifyException {
  NotifyInsufficientCreditsException(super.message);
}

/// Creates a notifications client aimed at data-connector routes.
Future<NotificationsClient> createNotificationsClient({
  required String dataConnectorUrl,
}) async {
  final trimmed = dataConnectorUrl.trim();
  if (trimmed.isEmpty) {
    throw NotifyException(
      'Ebm.dataConnectorUrl is required for notifications '
      '(do not use taxServerUrl)',
    );
  }
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  return NotificationsClient(baseUrl: base);
}

/// `j***@example.com` — enough to tell which guest, not enough to be a leak.
String _redactEmails(List<String> addresses) =>
    addresses.map(_redactEmail).join('","');

String _redactEmail(String address) {
  final at = address.indexOf('@');
  if (at <= 0) return '…';
  return '${address[0]}***${address.substring(at)}';
}

/// Keeps the last three digits so a wrong number is still recognisable.
String _redactPhones(List<String> numbers) =>
    numbers.map(_redactPhone).join('","');

String _redactPhone(String number) {
  final digits = number.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 4) return '…';
  return '…${digits.substring(digits.length - 3)}';
}

/// Keeps the parts of a notify response worth reading in a log — status,
/// credits, ids — and drops the guest's contact details.
String _redactedResponseBody(String body) {
  if (body.isEmpty) return body;
  try {
    final decoded = jsonDecode(body);
    if (decoded is! Map) return '{"…":"non-object response"}';
    return jsonEncode(_redactValue(Map<String, dynamic>.from(decoded)));
  } catch (_) {
    // Not JSON — an upstream error page could hold anything.
    return '{"…":"unparsed ${body.length} byte response"}';
  }
}

/// Recursively blanks any `to` field, at whatever depth the route nests it.
Object? _redactValue(Object? value) {
  if (value is Map) {
    return <String, Object?>{
      for (final entry in value.entries)
        entry.key.toString(): entry.key == 'to'
            ? '…'
            : _redactValue(entry.value),
    };
  }
  if (value is List) return value.map(_redactValue).toList();
  return value;
}
