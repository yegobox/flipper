import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

class BillingService {
  /// catch error on backend trying to use a voucher more than once
  /// I should not base on used property since this property is mutated
  /// after the use instead I should check this property before I mutate the voucher

  Future<Voucher?> useVoucher({int? voucher, int? userId}) async {
    Voucher? voucherUse =
        await ProxyService.isar.consumeVoucher(voucherCode: voucher!);
    if (voucherUse != null) {
      return voucherUse;
    } else {
      throw VoucherException(term: "Voucher not found");
    }
  }

  Pointss addPoints({int? points, int? userId}) {
    return ProxyService.isar.addPoint(userId: userId!, point: points!);
  }

  void monitorSubscription({required int userId}) async {
    /// monitor the subscription of the user
    /// the logic to check if it is a time to take a payment
    /// use points when the subscription is expired
    // ignore: todo
    // TODO: getSubscription api seem to return 404
    // Subscription? sub =
    //     await ProxyService.isar.getSubscription(userId: userId);
    // if (sub != null) {
    //   String date = sub.nextBillingDate;
    //   DateTime nextBillingDate = DateTime.parse(date);
    //   DateTime today = DateTime.now();

    //   if (nextBillingDate.isBefore(today)) {
    //     // if the user still have some point consume them and update the subscription
    //     Pointss? points = await ProxyService.isar.getPoints(userId: userId);
    //     if (points?.value != null && points!.value > 0) {
    //       ProxyService.isarApi
    //           .consumePoints(userId: userId, points: points.value);
    //       ProxyService.isar.addUpdateSubscription(
    //         userId: userId,
    //         interval: sub.interval,
    //         recurringAmount: sub.recurring,
    //         descriptor: sub.descriptor,
    //         features: [],
    //       );
    //     } else {
    //       //
    //     }
    //   }
    // }
  }
}
