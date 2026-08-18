import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Entitlement and purchases as Supabase RPC calls.
///
/// Every one of these is a `security definer` function rather than table
/// access, because writing a plan row at a price of the client's choosing must
/// not be something a signed-in session can do: data-connector treats
/// `plans.total_price` as authoritative when it charges.
class SupabaseHrBillingRepository implements HrBillingRepository {
  const SupabaseHrBillingRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<HrAccessState> fetchAccessState({String? businessId}) async {
    final raw = await _rpc(
      'hr_access_state',
      {'p_business_id': businessId},
      'Could not check this business\'s subscription.',
    );
    return HrAccessState.fromJson(raw);
  }

  @override
  Future<HrPlanQuote> quote({
    required String businessId,
    String slug = 'basic',
    bool isYearly = false,
  }) async {
    final raw = await _rpc('hr_plan_quote', {
      'p_business_id': businessId,
      'p_slug': slug,
      'p_is_yearly': isYearly,
    }, 'Could not load the price of this plan.');
    return HrPlanQuote.fromJson(raw);
  }

  @override
  Future<HrSubscriptionStart> startSubscription({
    required String businessId,
    String slug = 'basic',
    bool isYearly = false,
    String? phoneNumber,
  }) async {
    final raw = await _rpc('hr_start_subscription', {
      'p_business_id': businessId,
      'p_slug': slug,
      'p_is_yearly': isYearly,
      'p_phone': phoneNumber,
    }, 'Could not start the subscription.');
    return HrSubscriptionStart.fromJson(raw);
  }

  Future<Map<String, dynamic>> _rpc(
    String function,
    Map<String, dynamic> params,
    String failureMessage,
  ) async {
    try {
      final raw = await _client.rpc<dynamic>(function, params: params);
      if (raw is Map) return Map<String, dynamic>.from(raw);
      throw HrBillingException(failureMessage);
    } on PostgrestException catch (e) {
      if (_isMissingSchema(e)) throw const HrBillingSchemaMissing();
      // The functions raise their own sentences ("you do not manage this
      // business", "This plan covers 50 employees…"); those are better than
      // anything phrased here, so they are shown as-is when present.
      throw HrBillingException(
        e.message.trim().isEmpty ? failureMessage : e.message.trim(),
        cause: e,
      );
    } on HrBillingSchemaMissing {
      rethrow;
    } catch (e) {
      throw HrBillingException(failureMessage, cause: e);
    }
  }

  /// PostgREST reports an absent function as PGRST202, and an absent table or
  /// column as 42P01 / 42703. Any of the three means the migration has not run.
  static bool _isMissingSchema(PostgrestException e) {
    const codes = {'PGRST202', 'PGRST204', '42883', '42P01', '42703'};
    if (codes.contains(e.code)) return true;
    final message = e.message.toLowerCase();
    return message.contains('could not find the function') ||
        message.contains('does not exist');
  }
}
