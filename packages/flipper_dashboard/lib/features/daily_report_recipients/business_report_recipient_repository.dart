import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _logTag = '[BusinessReportRecipients]';

class BusinessReportRecipient {
  const BusinessReportRecipient({
    required this.id,
    required this.email,
    this.label,
  });

  final String id;
  final String email;
  final String? label;

  factory BusinessReportRecipient.fromSupabaseRow(Map<String, dynamic> row) {
    return BusinessReportRecipient(
      id: row['id']?.toString() ?? '',
      email: row['email']?.toString().trim() ?? '',
      label: row['label']?.toString().trim(),
    );
  }
}

class BusinessReportRecipientException implements Exception {
  BusinessReportRecipientException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BusinessReportRecipientRepository {
  BusinessReportRecipientRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<String?> _resolveBusinessUuid() async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) return null;
    return FlipperBaseModel.resolveBusinessUuidForTenants(businessId);
  }

  bool _isMissingTableError(PostgrestException e) {
    final code = e.code ?? '';
    final msg = e.message.toLowerCase();
    return code == '42P01' ||
        msg.contains('business_report_recipients') &&
            (msg.contains('does not exist') || msg.contains('not found'));
  }

  static bool isPlausibleEmail(String raw) {
    final s = raw.trim();
    if (s.length < 5) return false;
    final at = s.indexOf('@');
    if (at <= 0 || at >= s.length - 1) return false;
    final domain = s.substring(at + 1);
    if (!domain.contains('.')) return false;
    if (RegExp(r'^[\d+\s]+$').hasMatch(s)) return false;
    return true;
  }

  Future<List<BusinessReportRecipient>> listRecipients() async {
    final businessUuid = await _resolveBusinessUuid();
    if (businessUuid == null || businessUuid.isEmpty) return const [];

    try {
      final rows = await _client
          .from('business_report_recipients')
          .select('id,email,label')
          .eq('business_id', businessUuid)
          .order('created_at');
      return rows
          .map((r) => BusinessReportRecipient.fromSupabaseRow(
                Map<String, dynamic>.from(r as Map),
              ))
          .where((r) => r.email.isNotEmpty)
          .toList();
    } on PostgrestException catch (e, st) {
      if (_isMissingTableError(e)) {
        talker.warning(
          '$_logTag business_report_recipients table missing — apply migration '
          '20260630140000_business_report_recipients.sql',
        );
        return const [];
      }
      talker.error('$_logTag listRecipients failed', e, st);
      rethrow;
    }
  }

  Future<BusinessReportRecipient> addRecipient({
    required String email,
    String? label,
  }) async {
    final trimmed = email.trim();
    if (!isPlausibleEmail(trimmed)) {
      throw BusinessReportRecipientException('Enter a valid email address.');
    }

    final businessUuid = await _resolveBusinessUuid();
    if (businessUuid == null || businessUuid.isEmpty) {
      throw BusinessReportRecipientException('No business selected.');
    }

    final payload = <String, dynamic>{
      'business_id': businessUuid,
      'email': trimmed,
      if (label != null && label.trim().isNotEmpty) 'label': label.trim(),
    };

    try {
      final row = await _client
          .from('business_report_recipients')
          .insert(payload)
          .select('id,email,label')
          .single();
      return BusinessReportRecipient.fromSupabaseRow(
        Map<String, dynamic>.from(row),
      );
    } on PostgrestException catch (e) {
      if (_isMissingTableError(e)) {
        throw BusinessReportRecipientException(
          'Daily report recipients are not set up yet. Ask your admin to run '
          'the latest Supabase migration (business_report_recipients).',
        );
      }
      final msg = e.message.toLowerCase();
      if (msg.contains('duplicate') || msg.contains('unique')) {
        throw BusinessReportRecipientException(
          'That email is already on the daily report list.',
        );
      }
      throw BusinessReportRecipientException(
        e.message.isNotEmpty ? e.message : 'Could not add recipient.',
      );
    }
  }

  Future<void> deleteRecipient(String id) async {
    if (id.isEmpty) return;
    try {
      await _client.from('business_report_recipients').delete().eq('id', id);
    } on PostgrestException catch (e) {
      if (_isMissingTableError(e)) {
        throw BusinessReportRecipientException(
          'Daily report recipients are not set up yet.',
        );
      }
      throw BusinessReportRecipientException(
        e.message.isNotEmpty ? e.message : 'Could not remove recipient.',
      );
    }
  }
}
