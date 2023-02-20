import 'dart:async';
import 'dart:io';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:timezone/timezone.dart' as tz;

class CronService {
  final settingService = locator<SettingsService>();
  final printer = locator<Printer>();
  final log = getLogger('CronService');
  final drive = GoogleDrive();

  void companyWideReport() {}

  void customerBasedReport() {}
  //bluethooth should search and auto connect to any near bluethoopt printer.
  //the setting should enable this i.e toggled to true i.e we will start the search process on app startup
  //the search process should be triggered by a button on the settings page
  connectBlueToothPrinter() {}

  deleteReceivedMessageFromServer() {}

  //the default file that will be generated and saved in known app folder
  //will be printed everytime a sales is complete for demo
  //after demo i.e that time we will be sure that bluethooth is working
  // then we will customize invoice to match with actual data.
  schedule() async {
    //save the device token to firestore if it is not already there
    Business? business = await ProxyService.isarApi.getBusiness();
    String? token;
    if (!Platform.isWindows) {
      token = await FirebaseMessaging.instance.getToken();

      Map updatedBusiness = business!.toJson();
      updatedBusiness['deviceToken'] = token.toString();
    }
    Timer.periodic(Duration(minutes: 30), (Timer t) async {
      if (ProxyService.box.hasSignedInForAutoBackup()) {
        drive.upload();
      }
    });

    // we need to think when the devices change or app is uninstalled
    // for the case like that the token needs to be updated, but not covered now
    // this sill make more sence once we implement the sync that is when we will implement such solution
    Set<int> processedOrders = Set();

    Timer.periodic(Duration(minutes: 30), (Timer t) async {
      /// removing checkIn flag will allow the user to check in again
      //String userId = ProxyService.box.getUserId()!;
      //ProxyService.billing.monitorSubscription(userId: int.parse(userId));
      //ProxyService.box.remove(key: 'checkIn');

      /// get unsynced counter and send them online for houseKeping.
      List<Counter> counters = await ProxyService.isarApi
          .unSyncedCounters(branchId: ProxyService.box.getBranchId()!);
      for (Counter counter in counters) {
        ProxyService.isarApi.update(data: counter..backed = true);
      }
      // ignore: todo
      //TODO:fix this to get this from settings await settingService.isDailyReportEnabled()
      if (true) {
        List<Order> completedOrders = await ProxyService.isarApi
            .completedOrders(branchId: ProxyService.box.getBranchId()!);
        print('how many time cron runs');

        for (Order completedOrder in completedOrders) {
          if (processedOrders.contains(completedOrder.id)) {
            return;
          }

          if ((completedOrder.reported!) == false) {
            List<OrderItem> updatedItems = await ProxyService.isarApi
                .orderItems(orderId: completedOrder.id);
            String namesString =
                updatedItems.map((item) => item.name).join(',');
            completedOrder.subTotal =
                updatedItems.fold(0, (a, b) => a + (b.price * b.qty));

            /// fix@issue where the createdAt synced on server is older compared to when a transaction was completed.
            completedOrder.updatedAt = DateTime.now().toIso8601String();
            completedOrder.createdAt = DateTime.now().toIso8601String();
            completedOrder.reported = true;

            if (await ProxyService.appService.checkInternetConnectivity()) {
              ProxyService.notification.localNotification(
                  1,
                  "Backup data",
                  "we are backing up your data",
                  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));
              try {
                await ProxyService.isarApi.update(data: completedOrder);
                await ProxyService.remoteApi.create(
                    collection: completedOrder.toJson(
                        convertIdToString: true, itemName: namesString),
                    collectionName: 'orders');

                processedOrders.add(completedOrder.id);
              } catch (e, stackTrace) {
                completedOrder.reported = false;
                completedOrder.status = postPonedStatus;
                await ProxyService.isarApi.update(data: completedOrder);
                ProxyService.crash.reportError(e, stackTrace);
              }
            }
          }
        }
      }
    });
  }
}
