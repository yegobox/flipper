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

  /// Inserts a new request. Server sets [accept_deadline_at] to now + 30 minutes.
  Future<ServiceGigRequest> createRequest({
    required String providerUserId,
    String? requestedService,
    required String customerMessage,
  }) async {
    final customerId = ProxyService.box.getUserId();
    if (customerId == null || customerId.isEmpty) {
      throw ServiceGigRequestException('Sign in to request a service.');
    }
    if (customerId == providerUserId) {
      throw ServiceGigRequestException('You cannot request a service from yourself.');
    }

    final payload = <String, dynamic>{
      'customer_user_id': customerId,
      'provider_user_id': providerUserId,
      'customer_message': customerMessage.trim(),
      'customer_business_id': ProxyService.box.getBusinessId(),
      'customer_branch_id': ProxyService.box.getBranchId(),
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
    if (current.paymentDeadlineAt != null &&
        DateTime.now().toUtc().isAfter(current.paymentDeadlineAt!)) {
      throw ServiceGigRequestException(
        'The payment window has ended. Contact the provider to send a new request.',
      );
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
