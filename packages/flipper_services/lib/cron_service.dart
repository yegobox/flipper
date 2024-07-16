import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
    // await ProxyService.sync.pull();
    sendPort.send('Done sending data to http server');
  }

  final talker = TalkerFlutter.init();
  Future<void> _spawnIsolate(String name, dynamic isolateHandler) async {
    if (ProxyService.box.getBusinessId() == null) return;
    try {
      Business business = ProxyService.local.localRealm!.query<Business>(
          r'serverId == $0', [ProxyService.box.getBusinessId()!]).first;
      // talker.warning("Business ID ${ProxyService.box.getBusinessId()}");
      if (ProxyService.realm.isTaxEnabled()) {
        ReceivePort receivePort = ReceivePort();
        final isolate = await Isolate.spawn(
          isolateHandler,
          [
            RootIsolateToken.instance,
            receivePort.sendPort,
            ProxyService.box.getBranchId()!,
            await ProxyService.realm
                .dbPath(path: name, folder: ProxyService.box.getBusinessId()),
            ProxyService.box.encryptionKey(),
            business.tinNumber,
            ProxyService.box.bhfId() ?? "00",
            ProxyService.box.getBusinessId(),
            ProxyService.box.getServerUrl()
          ],
        );

        receivePort.listen(
          (message) async {
            /// receive computed value that is considered that we have successfully completed updating EBM server
            /// then it is time to update the database and mark the model as updated this will help us to know
            /// if we are in sync with EBM server for all models we have inside our app
            String identifier = message as String;
            List<String> separator = identifier.split(":");
            talker.warning(
                "About to update model ${separator.first} with ${separator.last}");
            if (separator.first == "variant") {
              // find this variant in db
              Variant variant = ProxyService.realm.realm!
                  .query<Variant>(r'id == $0', [separator.last]).first;
              ProxyService.realm.markModelForEbmUpdate<Variant>(model: variant);
            }
            if (separator.first == "stock") {
              // find this variant in db
              Stock stock = ProxyService.realm.realm!
                  .query<Stock>(r'id == $0', [separator.last]).first;

              ProxyService.realm.markModelForEbmUpdate<Stock>(model: stock);
            }
            if (separator.first == "notification") {
              /// in event when we are done with work in isolate
              /// then we kill current isolate, but it is very important to know
              /// that we receive this notification from isolate only when some work was done inside isolate
              /// this means if there is no work done, the isolate will fail to trigger the kill event to use to be able
              /// to kill the current isolate, this is why we have at the bottom of the code to forcefully kill whatever isolate
              /// that is hanging somewhere around
              isolate.kill();
              ProxyService.notification
                  .sendLocalNotification(body: "System is up to date with EBM");
            }

            await ProxyService.realm.realm!.subscriptions
                .waitForSynchronization();
          },
        );
        // Isolate.current.addOnExitListener(await receivePort.last);
        await Future.delayed(const Duration(seconds: 20));
        isolate.kill();
      }
    } catch (error, s) {
      talker.warning('Error managing isolates: $s');
    }
  }

  /// Schedules various tasks and timers to handle data synchronization, device publishing, and other periodic operations.
  ///
  /// This method sets up the following scheduled tasks:
  /// - Initializes Firebase messaging and subscribes to business notifications.
  /// - Periodically pulls data from Realm.
  /// - Periodically pushes data to the server.
  /// - Periodically synchronizes Firestore data.
  /// - Periodically runs a demo print operation.
  /// - Periodically pulls data from the server.
  /// - Periodically attempts to publish the device to the server.
  ///
  /// The durations of these tasks are determined by the corresponding private methods.
  Future<void> schedule() async {
    // create a compute function to keep track of unsaved data back to EBM do this in background

    Timer.periodic(_getHeartBeatDuration(), (Timer t) async {
      if (ProxyService.box.getUserId() == null ||
          ProxyService.box.getBusinessId() == null) return;

      /// bootstrap data for universal Product names;

      await _spawnIsolate("local", IsolateHandler.localData);

      await _spawnIsolate("synced", IsolateHandler.handleEBMTrigger);
    });

    await _setupFirebase();

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
      // ProxyService.realm.sendScheduleMessages();
      // await _keepTryingPublishDevice(); // Add this line
    });

    // Other scheduled tasks...
  }

  Future<void> _keepTryingPublishDevice() async {
    // Implement the logic for keepTryingPublishDevice
    ProxyService.event.keepTryingPublishDevice();
  }

  Future<void> _setupFirebase() async {
    Business? business = await ProxyService.local.getBusiness();
    ProxyService.syncFirestore.configure();
    String? token;

    if (!Platform.isWindows && !isMacOs && !isIos) {
      token = await FirebaseMessaging.instance.getToken();

      Map updatedBusiness = business.toEJson() as Map<String, dynamic>;
      updatedBusiness['deviceToken'] = token.toString();
    }
  }

  Future<void> _syncPullData() async {
    if (ProxyService.remoteConfig.isSyncAvailable() &&
        ProxyService.remoteConfig.isHttpSyncAvailable()) {
      // ProxyService.sync.pull();
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

  Duration _getHeartBeatDuration() {
    return Duration(seconds: kDebugMode ? 20 : 60);
  }

  _heartBeatPull() async {
    await compute(_backgroundHeartBeat, null);
  }

  static void _backgroundHeartBeat(_) {
    // This function will run in a separate isolate
    // Perform the heartBeat operation here
    //ProxyService.realm.heartBeat();
  }
}
