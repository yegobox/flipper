import 'dart:io';

import 'package:cron/cron.dart';
// import 'package:flipper_models/models/models.dart' as box;
import 'package:flipper_models/isar_models.dart';
// import 'package:flipper_models/order_item.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_services/setting_service.dart';

class CronService {
  final cron = Cron();
  final settingService = locator<SettingsService>();
  final printer = locator<Printer>();
  final log = getLogger('CronService');
  final drive = GoogleDrive();

  /// This is the report mainly for yegobox|flipper business
  /// the report shall help the company know what customers are selling
  /// when they are selling the item and to him plus any other relevant information
  /// that can help sales team to develop product and increase sales
  void companyWideReport() {}

  /// this report should be sent to a customer given email.
  /// for a daly report, should create a spreadsheet tab naming it with the date of the report
  /// when a customer update the email, it should trigger the server(us) to create a new google sheet document
  /// and add it to the setting modal of the client,then on report generation the same document should be used
  /// so the document will be share do the user's email.
  /// check the user has spreadsheet document assigned, a log out and log in can assist
  /// since we update the business permissions and everytime a login happen we update business model from the server

  void customerBasedReport() {}
  //bluethooth should search and auto connect to any near bluethoopt printer.
  //the setting should enable this i.e toggled to true i.e we will start the search process on app startup
  //the search process should be triggered by a button on the settings page
  connectBlueToothPrinter() {
    //this is the code to connect to bluetooth printer
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      // log.i('start connecting bluethooth');
      // printer.connect();
    });
  }

  deleteReceivedMessageFromServer() {
    // cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    //   log.i('scheduled delete message');
    //   ProxyService.isarApi.emptyQueue();
    // });
  }

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

    /// load new contacts i.e business every 5 minutes
    /// this will be used to update the business model
    /// TODOchange this to avoid multiple api calls to the server
    /// load them when app start then do it later every 15 minutes
    // ProxyService.isarApi.getContacts();
    // cron.schedule(Schedule.parse('*/45 * * * *'), () async {
    //   ProxyService.isarApi.getContacts();
    // });

    /// backup the user db every day
    // cron.schedule(Schedule.parse('*/60 * * * *'), () async {
    //   log.i('downloading the remote  copy');
    //   // for now enable backup for all clients in future this will be changed
    //   // Business? business = await ProxyService.isarApi.getBusiness();
    //   // prevent the backup pop-up when a user did not click on adding backup button.
    //   if (ProxyService.box.hasSignedInForAutoBackup()) {
    //     await drive.downloadGoogleDriveFile(
    //         'mdbx.dat', ProxyService.box.gdID());

    //     Directory test = await getApplicationDocumentsDirectory();

    //     await for (var entity
    //         in test.list(recursive: true, followLinks: false)) {
    //       log.i(entity.path);
    //     }
    //   }
    // });
    cron.schedule(Schedule.parse('*/30 * * * *'), () async {
      log.i('uploading the local copy');
      // for now enable backup for all clients in future this will be changed
      // Business? business = await ProxyService.isarApi.getBusiness();
      // prevent the backup pop-up when a user did not click on adding backup button.
      if (ProxyService.box.hasSignedInForAutoBackup()) {
        drive.upload();
      }
    });

    // we need to think when the devices change or app is uninstalled
    // for the case like that the token needs to be updated, but not covered now
    // this sill make more sence once we implement the sync that is when we will implement such solution

    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      /// removing checkIn flag will allow the user to check in again
      String userId = ProxyService.box.getUserId()!;
      ProxyService.billing.monitorSubscription(userId: int.parse(userId));
      ProxyService.box.remove(key: 'checkIn');
      // ignore: todo
      //TODO:fix this to get this from settings await settingService.isDailyReportEnabled()
      if (true) {
        List<Order> completedOrders = await ProxyService.isarApi
            .completedOrders(branchId: ProxyService.box.getBranchId()!);

        for (Order completedOrder in completedOrders) {
          log.i('syncing and reporting');
          if (!completedOrder.reported!) {
            await ProxyService.isarApi.sync(data: completedOrder);
            completedOrder.reported = true;
            await ProxyService.isarApi.update(data: completedOrder);
          }

          // List<OrderItem> items =
          //     await ProxyService.isarApi.orderItems(orderId: completedOrder.id);
          // final response =
          //     await ProxyService.isarApi.sendReport(orderItems: items);
          // if (response == 200) {
          //   completedOrder.reported = true;
          //   ProxyService.isarApi.update(data: completedOrder);
          // }
        }
      }
    });
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      /// get unsynced counter and send them online for houseKeping.
      List<Counter> counters = await ProxyService.isarApi
          .unSyncedCounters(branchId: ProxyService.box.getBranchId()!);
      for (Counter counter in counters) {
        ProxyService.isarApi.update(data: counter..backed = true);
      }
    });
  }
}
