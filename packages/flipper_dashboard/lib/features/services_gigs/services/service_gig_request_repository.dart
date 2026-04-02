import 'package:flipper_dashboard/features/services_gigs/models/service_gig_chat_message.dart';
import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceGigRequestException implements Exception {
  final String message;
  ServiceGigRequestException(this.message);

  @override
  String toString() => message;
}

/// Creates and reads service gig requests in Supabase.
class ServiceGigRequestRepository {
  ServiceGigRequestRepository();

  static const _table = 'service_gig_requests';
  static const _messagesTable = 'service_gig_request_messages';

  /// Inserts a new request. Server sets [accept_deadline_at] to now + 30 minutes.
  /// [paymentAmountRwf] is stored as the agreed budget and prefills MTN payment later.
  Future<ServiceGigRequest> createRequest({
    required String providerUserId,
    String? requestedService,
    required String customerMessage,
    required int paymentAmountRwf,
  }) async {
    final customerId = ProxyService.box.getUserId();
    if (customerId == null || customerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to request a service.');
    }
    if (customerId == providerUserId) {
      throw ServiceGigRequestException('You cannot request a service from yourself.');
    }
    if (paymentAmountRwf < 100) {
      throw ServiceGigRequestException('Enter an amount of at least 100 RWF.');
    }

    final payload = <String, dynamic>{
      'customer_user_id': customerId,
      'provider_user_id': providerUserId,
      'customer_message': customerMessage.trim(),
      'customer_business_id': ProxyService.box.getBusinessId(),
      'customer_branch_id': ProxyService.box.getBranchId(),
      'payment_amount_rwf': paymentAmountRwf,
    };
    if (requestedService != null && requestedService.trim().isNotEmpty) {
      payload['requested_service'] = requestedService.trim();
    }

    try {
      final row = await Supabase.instance.client
          .from(_table)
          .insert(payload)
          .select()
          .single();
      return ServiceGigRequest.fromJson(Map<String, dynamic>.from(row));
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not send your request.',
      );
    } catch (e) {
      throw ServiceGigRequestException(
        'Could not send your request. Check your connection and try again.',
      );
    }
  }

  /// Requests where the current user is the customer (newest first).
  Future<List<ServiceGigRequest>> listOutgoingForCustomer() async {
    final customerId = ProxyService.box.getUserId();
    if (customerId == null || customerId.isEmpty) return [];

    try {
      final response = await Supabase.instance.client
          .from(_table)
          .select()
          .eq('customer_user_id', customerId)
          .order('created_at', ascending: false) as List<dynamic>;

      return response
          .map(
            (e) => ServiceGigRequest.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// After MTN confirms payment: mark gig as paid (customer-only, within payment window).
  /// [mtnSettledAmountRwf] / MTN ids come from request-to-pay status (commission / reconciliation).
  Future<ServiceGigRequest> markCustomerPaymentComplete({
    required String requestId,
    required int paymentAmountRwf,
    String? mtnFinancialTransactionId,
    String? mtnPaymentReference,
    int? mtnSettledAmountRwf,
  }) async {
    final customerId = ProxyService.box.getUserId();
    if (customerId == null || customerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to complete payment.');
    }
    if (paymentAmountRwf < 1) {
      throw ServiceGigRequestException('Enter a valid amount.');
    }

    final existing = await Supabase.instance.client
        .from(_table)
        .select()
        .eq('id', requestId)
        .eq('customer_user_id', customerId)
        .maybeSingle();

    if (existing == null) {
      throw ServiceGigRequestException('Request not found.');
    }

    final current = ServiceGigRequest.fromJson(
      Map<String, dynamic>.from(existing),
    );
    if (current.status != 'pending_payment') {
      throw ServiceGigRequestException(
        'This request is not waiting for payment.',
      );
    }
    // Block stale pay attempts without MoMo proof. If MTN already succeeded, still record payment
    // even when the UI deadline passed (clock skew / slow polling / user paid at the last minute).
    if (current.paymentDeadlineAt != null &&
        DateTime.now().toUtc().isAfter(current.paymentDeadlineAt!)) {
      final hasMtnProof = (mtnFinancialTransactionId != null &&
              mtnFinancialTransactionId.trim().isNotEmpty) ||
          (mtnPaymentReference != null &&
              mtnPaymentReference.trim().isNotEmpty);
      if (!hasMtnProof) {
        throw ServiceGigRequestException(
          'The payment window has ended. Contact the provider to send a new request.',
        );
      }
    }

    final now = DateTime.now().toUtc();

    final updatePayload = <String, dynamic>{
      'status': 'paid',
      'payment_amount_rwf': paymentAmountRwf,
      'updated_at': now.toIso8601String(),
      'paid_at': now.toIso8601String(),
    };
    if (mtnFinancialTransactionId != null &&
        mtnFinancialTransactionId.isNotEmpty) {
      updatePayload['mtn_financial_transaction_id'] = mtnFinancialTransactionId;
    }
    if (mtnPaymentReference != null && mtnPaymentReference.isNotEmpty) {
      updatePayload['mtn_payment_reference'] = mtnPaymentReference;
    }
    if (mtnSettledAmountRwf != null && mtnSettledAmountRwf > 0) {
      updatePayload['mtn_settled_amount_rwf'] = mtnSettledAmountRwf;
    }

    try {
      final rows = await Supabase.instance.client
              .from(_table)
              .update(updatePayload)
              .eq('id', requestId)
              .eq('customer_user_id', customerId)
              .eq('status', 'pending_payment')
              .select()
          as List<dynamic>;

      if (rows.isEmpty) {
        throw ServiceGigRequestException(
          'Could not confirm payment. It may have already been recorded.',
        );
      }
      return ServiceGigRequest.fromJson(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } on ServiceGigRequestException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not save payment.',
      );
    } catch (_) {
      throw ServiceGigRequestException(
        'Could not save payment. Check your connection.',
      );
    }
  }

  /// Requests where the current user is the provider (newest first).
  Future<List<ServiceGigRequest>> listIncomingForProvider() async {
    final providerId = ProxyService.box.getUserId();
    if (providerId == null || providerId.isEmpty) return [];

    try {
      final response = await Supabase.instance.client
          .from(_table)
          .select()
          .eq('provider_user_id', providerId)
          .order('created_at', ascending: false) as List<dynamic>;

      return response
          .map(
            (e) => ServiceGigRequest.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Accept: customer has 5 minutes to pay (`pending_payment`).
  Future<ServiceGigRequest> acceptRequest(String requestId) async {
    final providerId = ProxyService.box.getUserId();
    if (providerId == null || providerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to respond to requests.');
    }

    final now = DateTime.now().toUtc();
    final paymentDeadline = now.add(const Duration(minutes: 5));

    try {
      final rows = await Supabase.instance.client
              .from(_table)
              .update({
                'status': 'pending_payment',
                'accepted_at': now.toIso8601String(),
                'payment_deadline_at': paymentDeadline.toIso8601String(),
                'updated_at': now.toIso8601String(),
              })
              .eq('id', requestId)
              .eq('provider_user_id', providerId)
              .eq('status', 'requested')
              .select()
          as List<dynamic>;

      if (rows.isEmpty) {
        throw ServiceGigRequestException(
          'This request can no longer be accepted. It may have expired or already been handled.',
        );
      }
      return ServiceGigRequest.fromJson(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } on ServiceGigRequestException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not accept the request.',
      );
    } catch (_) {
      throw ServiceGigRequestException(
        'Could not accept the request. Check your connection and try again.',
      );
    }
  }

  /// Single request if the signed-in user is the customer or provider.
  Future<ServiceGigRequest?> getRequestForParticipant(String requestId) async {
    final uid = ProxyService.box.getUserId();
    if (uid == null || uid.isEmpty) return null;
    try {
      final row = await Supabase.instance.client
          .from(_table)
          .select()
          .eq('id', requestId)
          .maybeSingle();
      if (row == null) return null;
      final r = ServiceGigRequest.fromJson(Map<String, dynamic>.from(row));
      if (r.customerUserId != uid && r.providerUserId != uid) return null;
      return r;
    } catch (_) {
      return null;
    }
  }

  /// Jobs with recorded payment: count and sum of [payment_amount_rwf] for dashboard.
  Future<ProviderGigEarningsSummary> summarizeProviderEarnings(
    String providerUserId,
  ) async {
    if (providerUserId.isEmpty) {
      return const ProviderGigEarningsSummary(
        fundedJobCount: 0,
        totalPaymentRwf: 0,
      );
    }
    try {
      final response = await Supabase.instance.client
              .from(_table)
              .select('status,payment_amount_rwf')
              .eq('provider_user_id', providerUserId) as List<dynamic>;

      const active = {'paid', 'in_progress', 'completed'};
      var count = 0;
      var sum = 0;
      for (final e in response) {
        final map = Map<String, dynamic>.from(e as Map);
        final st = map['status']?.toString() ?? '';
        if (!active.contains(st)) continue;
        final amt = map['payment_amount_rwf'];
        final n = amt is int
            ? amt
            : int.tryParse(amt?.toString() ?? '') ?? 0;
        if (n > 0) {
          count++;
          sum += n;
        }
      }
      return ProviderGigEarningsSummary(
        fundedJobCount: count,
        totalPaymentRwf: sum,
      );
    } catch (_) {
      return const ProviderGigEarningsSummary(
        fundedJobCount: 0,
        totalPaymentRwf: 0,
      );
    }
  }

  Future<List<ServiceGigChatMessage>> listMessages(String requestId) async {
    final r = await getRequestForParticipant(requestId);
    if (r == null) return [];
    try {
      final response = await Supabase.instance.client
              .from(_messagesTable)
              .select()
              .eq('request_id', requestId)
              .order('created_at', ascending: true) as List<dynamic>;

      return response
          .map(
            (e) => ServiceGigChatMessage.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> sendMessage({
    required String requestId,
    required String body,
  }) async {
    final uid = ProxyService.box.getUserId();
    if (uid == null || uid.isEmpty) {
      throw ServiceGigRequestException('Sign in to send a message.');
    }
    final trimmed = body.trim();
    if (trimmed.isEmpty) {
      throw ServiceGigRequestException('Message cannot be empty.');
    }
    final r = await getRequestForParticipant(requestId);
    if (r == null) {
      throw ServiceGigRequestException('Request not found.');
    }
    const blocked = {'declined', 'expired', 'cancelled'};
    if (blocked.contains(r.status)) {
      throw ServiceGigRequestException('This request is closed.');
    }
    try {
      await Supabase.instance.client.from(_messagesTable).insert({
        'request_id': requestId,
        'sender_user_id': uid,
        'body': trimmed,
      });
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not send message.',
      );
    } catch (_) {
      throw ServiceGigRequestException('Could not send message.');
    }
  }

  Future<ServiceGigRequest> providerStartJob(String requestId) async {
    final providerId = ProxyService.box.getUserId();
    if (providerId == null || providerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to update this request.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    try {
      final rows = await Supabase.instance.client
              .from(_table)
              .update({
                'status': 'in_progress',
                'provider_started_at': now,
                'updated_at': now,
              })
              .eq('id', requestId)
              .eq('provider_user_id', providerId)
              .eq('status', 'paid')
              .select()
          as List<dynamic>;

      if (rows.isEmpty) {
        throw ServiceGigRequestException(
          'Only paid requests that have not started can be moved to in progress.',
        );
      }
      return ServiceGigRequest.fromJson(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } on ServiceGigRequestException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not update status.',
      );
    } catch (_) {
      throw ServiceGigRequestException('Could not update status.');
    }
  }

  Future<ServiceGigRequest> providerCompleteJob(String requestId) async {
    final providerId = ProxyService.box.getUserId();
    if (providerId == null || providerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to update this request.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    try {
      final rows = await Supabase.instance.client
              .from(_table)
              .update({
                'status': 'completed',
                'provider_completed_at': now,
                'updated_at': now,
              })
              .eq('id', requestId)
              .eq('provider_user_id', providerId)
              .inFilter('status', ['paid', 'in_progress'])
              .select()
          as List<dynamic>;

      if (rows.isEmpty) {
        throw ServiceGigRequestException(
          'Could not mark complete. It may already be finished.',
        );
      }
      return ServiceGigRequest.fromJson(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } on ServiceGigRequestException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not update status.',
      );
    } catch (_) {
      throw ServiceGigRequestException('Could not update status.');
    }
  }

  Future<ServiceGigRequest> submitCustomerReview({
    required String requestId,
    required int rating,
    required String comment,
  }) async {
    final customerId = ProxyService.box.getUserId();
    if (customerId == null || customerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to leave a review.');
    }
    if (rating < 1 || rating > 5) {
      throw ServiceGigRequestException('Pick a rating from 1 to 5.');
    }
    final c = comment.trim();
    if (c.length < 4) {
      throw ServiceGigRequestException('Please add a short comment.');
    }
    final before = await getRequestForParticipant(requestId);
    if (before == null || before.customerUserId != customerId) {
      throw ServiceGigRequestException('Request not found.');
    }
    if (before.status != 'completed') {
      throw ServiceGigRequestException('Only completed jobs can be reviewed.');
    }
    if (before.customerRating != null) {
      throw ServiceGigRequestException('You already left a review.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    try {
      final rows = await Supabase.instance.client
              .from(_table)
              .update({
                'customer_rating': rating,
                'customer_review': c,
                'review_submitted_at': now,
                'updated_at': now,
              })
              .eq('id', requestId)
              .eq('customer_user_id', customerId)
              .eq('status', 'completed')
              .select()
          as List<dynamic>;

      if (rows.isEmpty) {
        throw ServiceGigRequestException('Could not save review. Try again.');
      }
      return ServiceGigRequest.fromJson(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } on ServiceGigRequestException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not save review.',
      );
    } catch (_) {
      throw ServiceGigRequestException('Could not save review.');
    }
  }

  Future<ServiceGigRequest> declineRequest(String requestId) async {
    final providerId = ProxyService.box.getUserId();
    if (providerId == null || providerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to respond to requests.');
    }

    final now = DateTime.now().toUtc();

    try {
      final rows = await Supabase.instance.client
              .from(_table)
              .update({
                'status': 'declined',
                'updated_at': now.toIso8601String(),
              })
              .eq('id', requestId)
              .eq('provider_user_id', providerId)
              .eq('status', 'requested')
              .select()
          as List<dynamic>;

      if (rows.isEmpty) {
        throw ServiceGigRequestException(
          'This request can no longer be declined. It may have expired or already been handled.',
        );
      }
      return ServiceGigRequest.fromJson(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } on ServiceGigRequestException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServiceGigRequestException(
        e.message.isNotEmpty ? e.message : 'Could not decline the request.',
      );
    } catch (_) {
      throw ServiceGigRequestException(
        'Could not decline the request. Check your connection and try again.',
      );
    }
  }
}
