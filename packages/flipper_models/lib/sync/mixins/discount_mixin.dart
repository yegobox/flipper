import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin DiscountMixin {
  /// Validates a discount code against business rules
  Future<Map<String, dynamic>> validateDiscountCode({
    required String code,
    required String planName,
    required double amount,
  }) async {
    try {
      final response =
          await Supabase.instance.client.rpc('validate_discount_code', params: {
        'p_code': code,
        'p_plan_name': planName,
        'p_amount': amount,
      }).single();

      return response;
    } catch (e) {
      talker.error('Failed to validate discount code: $e');
      return {
        'is_valid': false,
        'error_message': 'Failed to validate code: $e',
      };
    }
  }

  /// Applies a discount to a plan and tracks it in plan_discounts table
  Future<String?> applyDiscountToPlan({
    required String planId,
    required String discountCodeId,
    required double originalPrice,
    required double discountAmount,
    required double finalPrice,
    required String businessId,
  }) async {
    try {
      final response =
          await Supabase.instance.client.rpc('apply_discount_to_plan', params: {
        'p_plan_id': planId,
        'p_discount_code_id': discountCodeId,
        'p_original_price': originalPrice,
        'p_discount_amount': discountAmount,
        'p_final_price': finalPrice,
        'p_business_id': businessId,
      });

      talker.info('Discount applied successfully to plan $planId');
      return response as String?;
    } catch (e) {
      talker.error('Failed to apply discount: $e');
      throw Exception('Failed to apply discount: $e');
    }
  }

  /// Retrieves discount information for a specific plan
  Future<Map<String, dynamic>?> getPlanDiscount({
    required String planId,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from('plan_discounts')
          .select('*, discount_codes(*)')
          .eq('plan_id', planId)
          .maybeSingle();

      return response;
    } catch (e) {
      talker.error('Failed to get plan discount: $e');
      return null;
    }
  }

  /// Calculates discount amount based on type and value
  double calculateDiscount({
    required double originalPrice,
    required String discountType,
    required double discountValue,
  }) {
    if (discountType == 'percentage') {
      return originalPrice * (discountValue / 100);
    } else {
      // Fixed amount
      return discountValue;
    }
  }
}
