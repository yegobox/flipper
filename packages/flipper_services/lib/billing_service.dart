import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.logger.dart';

class BillingService {
  final log = getLogger('BillingService');

  /// catch error on backend trying to use a voucher more than once
  /// I should not base on used property since this property is mutated
  /// after the use instead I should check this property before I mutate the voucher

  Future<Voucher?> useVoucher({int? voucher, int? userId}) async {
    Voucher? voucherUse =
        await ProxyService.isarApi.consumeVoucher(voucherCode: voucher!);
    if (voucherUse != null) {
      return voucherUse;
    } else {
      throw VoucherException(term: "Voucher not found");
    }
  }

  Points addPoints({int? points, int? userId}) {
    return ProxyService.isarApi.addPoint(userId: userId!, point: points!);
  }

  Future<Subscription> updateSubscription({
    required int userId,
    required int interval,
    required List<Feature> features,
    required String descriptor,
    required double amount,
  }) async {
    /// update the subscription of the user
    Subscription? sub = await ProxyService.isarApi.addUpdateSubscription(
      userId: userId,
      interval: interval,
      recurringAmount: amount,
      descriptor: descriptor,
      features: features,
    );
    return sub!;
  }

  Future<bool> activeSubscription() async {
    if (ProxyService.box.getUserId() == null) return false;
    int userId = int.parse(ProxyService.box.getUserId()!);
    Subscription? sub =
        await ProxyService.isarApi.getSubscription(userId: userId);
    if (sub != null) {
      String date = sub.nextBillingDate;
      DateTime nextBillingDate = DateTime.parse(date);
      DateTime today = DateTime.now();
      return nextBillingDate.isAfter(today);
    } else {
      return false;
    }
  }

  void monitorSubscription({required int userId}) async {
    /// monitor the subscription of the user
    /// the logic to check if it is a time to take a payment
    /// use points when the subscription is expired
    Subscription? sub =
        await ProxyService.isarApi.getSubscription(userId: userId);
    if (sub != null) {
      String date = sub.nextBillingDate;
      DateTime nextBillingDate = DateTime.parse(date);
      DateTime today = DateTime.now();

      if (nextBillingDate.isBefore(today)) {
        // if the user still have some point consume them and update the subscription
        Points? points = await ProxyService.isarApi.getPoints(userId: userId);
        if (points?.value != null && points!.value > 0) {
          ProxyService.isarApi
              .consumePoints(userId: userId, points: points.value);
          ProxyService.isarApi.addUpdateSubscription(
            userId: userId,
            interval: sub.interval,
            recurringAmount: sub.recurring,
            descriptor: sub.descriptor,
            features: [],
          );
        } else {
          ProxyService.notification.onDidReceiveLocalNotification(
              1,
              'Renew flipper subscription',
              'To continue using flipper,you need to renew your subscription', {
            'route': 'payment',
          });
        }
      }
    }
  }
}
