import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class CronService {
  final drive = GoogleDrive();

  Future<void> companyWideReport() async {
    // Implement company-wide report logic
  }

  Future<void> customerBasedReport() async {
    // Implement customer-based report logic
  }

  Future<void> connectBlueToothPrinter() async {
    // Implement Bluetooth connection logic
  }

  Future<void> deleteReceivedMessageFromServer() async {
    // Implement delete received message logic
  }

  Future<void> _remoteHttps(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    await initDependencies();
    await ProxyService.sync.pull();
    sendPort.send('Done sending data to http server');
  }

  Future<void> schedule() async {
    await _setupFirebase();
    await _setupRealm();

    /// pull does not have to wait as soon as we connect start pulling from realm.
    if (!isWeb) {
      ProxyService.realm.pull();
    }
    Timer.periodic(_getHeartBeatDuration(), (Timer t) async {
      await _heartBeatPull();
    });
    Timer.periodic(_getSyncPushDuration(), (Timer t) async {
      await _syncPushData();
    });

    Timer.periodic(_getFirebaseSyncDuration(), (Timer t) async {
      await _syncFirestoreData();
    });

    Timer.periodic(_getDemoPrintDuration(), (Timer t) async {
      await _runDemoPrint();
    });

    Timer.periodic(_getSyncPullDuration(), (Timer t) async {
      _syncPullData();
    });

    Timer.periodic(_getpublushingDeviceDuration(), (Timer t) async {
      ProxyService.isar.sendScheduleMessages();
      await _keepTryingPublishDevice(); // Add this line
    });

    // Other scheduled tasks...
  }

  Future<void> _keepTryingPublishDevice() async {
    // Implement the logic for keepTryingPublishDevice
    ProxyService.event.keepTryingPublishDevice();
  }

  Future<void> _setupFirebase() async {
    Business? business = await ProxyService.isar.getBusiness();
    ProxyService.syncFirestore.configure();
    String? token;

    if (!Platform.isWindows) {
      token = await FirebaseMessaging.instance.getToken();
      if (business != null) {
        Map updatedBusiness = business.toJson();
        updatedBusiness['deviceToken'] = token.toString();
      }
    }
  }

  Future<void> _syncPullData() async {
    if (ProxyService.remoteConfig.isSyncAvailable() &&
        ProxyService.remoteConfig.isHttpSyncAvailable()) {
      ProxyService.sync.pull();
    }
  }

  Future<void> _syncPushData() async {
    if (ProxyService.remoteConfig.isSyncAvailable() &&
        ProxyService.remoteConfig.isHttpSyncAvailable()) {
      await _runRemoteHttpsIsolate();
      ProxyService.messaging
          .initializeFirebaseMessagingAndSubscribeToBusinessNotifications();
    }
    // Other sync-related logic...
  }

  Future<void> _syncFirestoreData() async {
    if (ProxyService.remoteConfig.isSyncAvailable()) {
      // Implement Firestore sync logic
      // ProxyService.syncFirestore.pull();
    }
  }

  Future<void> _runDemoPrint() async {
    // Implement demo print logic
  }

  Future<void> _runRemoteHttpsIsolate() async {
    // Implement logic to run _remoteHttps in an isolate
  }

  Duration _getSyncPushDuration() {
    return Duration(minutes: kDebugMode ? 1 : 5);
  }

  Duration _getSyncPullDuration() {
    return Duration(minutes: kDebugMode ? 10 : 20);
  }

  Duration _getpublushingDeviceDuration() {
    return Duration(minutes: kDebugMode ? 10 : 20);
  }

  Duration _getFirebaseSyncDuration() {
    return Duration(minutes: kDebugMode ? 3 : 7);
  }

  Duration _getDemoPrintDuration() {
    return Duration(minutes: kDebugMode ? 10 : 20);
  }

  Future<void> _setupRealm() async {
    if (!isWeb) {
      await ProxyService.realm.configure();
    }
  }

  Duration _getHeartBeatDuration() {
    return Duration(minutes: kDebugMode ? 1 : 5);
  }

  _heartBeatPull() async {
    await compute(_backgroundHeartBeat, null);
  }

  static void _backgroundHeartBeat(_) {
    // This function will run in a separate isolate
    // Perform the heartBeat operation here
    ProxyService.realm.heartBeat();
  }
}
