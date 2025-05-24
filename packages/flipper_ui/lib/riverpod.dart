import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CouponValidationNotifier extends StateNotifier<AsyncValue<bool?>> {
//   CouponValidationNotifier() : super(const AsyncValue.data(null));

//   Future<void> validateCoupon(String couponCode) async {
//     state = const AsyncValue.loading();
//     try {
//       final isValid = await ProxyService.realmHttp.isCouponValid(
//         flipperHttpClient: ProxyService.http,
//         couponCode: couponCode,
//       );
//       state = AsyncValue.data(isValid);
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     }
//   }
// }

// final couponValidationProvider =
//     StateNotifierProvider<CouponValidationNotifier, AsyncValue<bool?>>(
//         (ref) => CouponValidationNotifier());

class CouponValidationNotifier extends StateNotifier<AsyncValue<bool?>> {
  CouponValidationNotifier() : super(const AsyncValue.data(null));

  Future<void> validateCoupon(String couponCode) async {
    state = const AsyncValue.loading();
    try {
      final isValid = await ProxyService.httpApi.isCouponValid(
        flipperHttpClient: ProxyService.http,
        couponCode: couponCode,
      );
      state = AsyncValue.data(isValid);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final couponValidationProvider =
    StateNotifierProvider<CouponValidationNotifier, AsyncValue<bool?>>(
        (ref) => CouponValidationNotifier());
