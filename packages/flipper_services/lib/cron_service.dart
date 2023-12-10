import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class CronService {
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
  Future<void> _remoteHttps(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    await ProxyService.sync.push();
    ProxyService.sync.pull();
  }

  schedule() async {
    //save the device token to firestore if it is not already there
    Business? business = await ProxyService.isar.getBusiness();
    ProxyService.syncFirestore.configure();
    String? token;
    Timer.periodic(Duration(minutes: kDebugMode ? 1 : 5), (Timer t) async {
      // get a list of local copy of product to sync

      if (ProxyService.remoteConfig.isSyncAvailable()) {
        RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
        if (rootIsolateToken == null) {
          print("Cannot get the RootIsolateToken");
          return;
        }
        ReceivePort receivePort = ReceivePort();
        await Isolate.spawn(
          _remoteHttps,
          [rootIsolateToken, receivePort.sendPort],
        );
        receivePort.listen((message) {
          print('Message from isolate: $message');
        });
        ProxyService.syncFirestore.pull();
      }

      ProxyService.messaging
          .initializeFirebaseMessagingAndSubscribeToBusinessNotifications();
      // in case pubnub did not get latest message load them forcefully
    });
    if (!Platform.isWindows) {
      token = await FirebaseMessaging.instance.getToken();
      if (business != null) {
        Map updatedBusiness = business.toJson();
        updatedBusiness['deviceToken'] = token.toString();
      }
    }
    Timer.periodic(Duration(hours: 5), (Timer t) async {
      if (ProxyService.box.hasSignedInForAutoBackup()) {
        drive.upload();
      }
    });

    // we need to think when the devices change or app is uninstalled
    // for the case like that the token needs to be updated, but not covered now
    // this sill make more sence once we implement the sync that is when we will implement such solution
    bool backOff = false;
    Timer.periodic(Duration(seconds: kDebugMode ? 10 : 10), (Timer t) async {
      /// get unsynced counter and send them online for houseKeping.
      try {
        if (!backOff) {
          ProxyService.isar.sendScheduleMessages();
          ProxyService.event.keepTryingPublishDevice();
        }
      } catch (e) {
        backOff = true;
      }
    });
    Timer.periodic(Duration(minutes: kDebugMode ? 1 : 10), (Timer t) async {
      /// get unsynced counter and send them online for houseKeping.
      if (ProxyService.box.getBranchId() != null) {
        // TODO: counters...
        // List<Counter> counters = await ProxyService.isar
        // .unSyncedCounters(branchId: ProxyService.box.getBranchId()!);
        // for (Counter counter in counters) {
        //   ProxyService.isar.update(data: counter..backed = true);
        // }
      }
    });
  }
}
