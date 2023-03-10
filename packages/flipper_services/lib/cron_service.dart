import 'dart:async';
import 'dart:io';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CronService {
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
    Timer.periodic(Duration(hours: 5), (Timer t) async {
      if (ProxyService.box.hasSignedInForAutoBackup()) {
        drive.upload();
      }
    });

    // we need to think when the devices change or app is uninstalled
    // for the case like that the token needs to be updated, but not covered now
    // this sill make more sence once we implement the sync that is when we will implement such solution

    Timer.periodic(Duration(minutes: 10), (Timer t) async {
      ProxyService.appService.backup();

      /// get unsynced counter and send them online for houseKeping.
      List<Counter> counters = await ProxyService.isarApi
          .unSyncedCounters(branchId: ProxyService.box.getBranchId()!);
      for (Counter counter in counters) {
        ProxyService.isarApi.update(data: counter..backed = true);
      }
    });

    Timer.periodic(Duration(minutes: 2), (Timer t) async {
      /// get a list of local copy of product to sync
      ProxyService.appService.pushDataToServer();
    });
  }
}
