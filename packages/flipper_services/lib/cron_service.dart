import 'dart:async';
import 'dart:io';
import 'dart:isolate';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/Subcriptions.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_models/DownloadQueue.dart';

import 'package:flipper_models/power_sync/powersync.dart';
import 'package:flipper_models/power_sync/schema.dart';

class CronService with Subscriptions {
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
  Isolate? isolate;

  final talker = TalkerFlutter.init();

  void isolateKill() {
    if (isolate != null) {
      isolate?.kill();
    }
  }

  Future<void> _spawnIsolate(String name, dynamic isolateHandler) async {
    if (ProxyService.box.getBusinessId() == null) return;
    try {
      Business business = ProxyService.local.localRealm!.query<Business>(
          r'serverId == $0', [ProxyService.box.getBusinessId()!]).first;
      // talker.warning("Business ID ${ProxyService.box.getBusinessId()}");
      if (ProxyService.realm
          .isTaxEnabled(business: ProxyService.local.getBusiness())) {
        ReceivePort receivePort = ReceivePort();

        /// kill any isolate that might be registered before we register new one!
        if (isolate != null) {
          isolateKill();
        }
        isolate = await Isolate.spawn(
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
            ProxyService.box.getServerUrl(),
            await ProxyService.realm.dbPath(
                path: 'local', folder: ProxyService.box.getBusinessId()),
          ],
        );

        receivePort.listen(
          (message) async {
            /// receive computed value that is considered that we have successfully completed updating EBM server
            /// then it is time to update the database and mark the model as updated this will help us to know
            /// if we are in sync with EBM server for all models we have inside our app
            String identifier = message as String;
            List<String> separator = identifier.split(":");
            // talker.warning(
            //     "About to update model ${separator.first} with ${separator.last}");
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
              isolate?.kill();
              ProxyService.notification
                  .sendLocalNotification(body: "System is up to date with EBM");
            }

            await ProxyService.realm.realm!.subscriptions
                .waitForSynchronization();
          },
        );
        // Isolate.current.addOnExitListener(await receivePort.last);
        await Future.delayed(const Duration(seconds: 20));
        isolate?.kill();
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
    if (await ProxyService.status.isInternetAvailable()) {
      // updateSubscription(
      //   branchId: ProxyService.box.getBranchId(),
      //   businessId: ProxyService.box.getBusinessId(),
      //   userId: ProxyService.box.getUserId(),
      //   realm: ProxyService.realm.realm,
      //   localRealm: ProxyService.local.localRealm,
      // );
    }

    /// keep assets downloaded and saved locally as they are added by other users in same business/branch
    Timer.periodic(_downloadFileSchele(), (Timer t) async {
      try {
        final downloadQueue = DownloadQueue(3);

        int branchId = ProxyService.box.getBranchId()!;
        if (ProxyService.realm.realm == null) {
          talker.warning("realm is null");
          return;
        }
        // ProxyService.box.writeBool(key: 'doneDownloadingAsset', value: false);
        if (!ProxyService.box.doneDownloadingAsset()) {
          List<Assets> assets = ProxyService.realm.realm!
              .query<Assets>(r'branchId == $0', [branchId]).toList();

          for (Assets asset in assets) {
            if (asset.assetName != null) {
              downloadQueue.addToQueue(
                DownloadParams(
                  branchId: branchId,
                  assetName: asset.assetName!,
                  subPath: "branch",
                ),
              );
            }
          }
        }
      } catch (e, s) {
        talker.warning(e);
        talker.error(s);
      } finally {
        ProxyService.box.writeBool(key: 'doneDownloadingAsset', value: true);
      }
    });

    Timer.periodic(_getBackUpDuration(), (Timer t) async {
      // final firestore = FirebaseFirestore.instance;
      // final backupService = BackupService(firestore);
      // await backupService.backUp(
      //   branchId: ProxyService.box.getBranchId()!,
      //   encryptionKey: ProxyService.box.encryptionKey(),
      //   dbPath: await ProxyService.realm
      //       .dbPath(path: 'synced', folder: ProxyService.box.getBusinessId()),
      // );
    });

    /// heart beat
    Timer.periodic(_getHeartBeatDuration(), (Timer t) async {
      backUpPowerSync();
      if (ProxyService.box.getUserId() == null ||
          ProxyService.box.getBusinessId() == null) return;

      /// bootstrap data for universal Product names;
      await _spawnIsolate("synced", IsolateHandler.flexibleSync);
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

  static String camelToSnakeCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match match) => '_${match.group(1)!.toLowerCase()}',
    );
  }

  static Future<Map<String, dynamic>> genericInsert({
    required String tableName,
    required Map<String, dynamic> data,
    String? returningClause,
  }) async {
    // Convert keys from camelCase to snake_case
    final convertedData =
        data.map((key, value) => MapEntry(camelToSnakeCase(key), value));

    // Separate UUID fields and regular fields
    final uuidFields = <String>[];
    final regularFields = <String>[];
    final values = <dynamic>[];

    convertedData.forEach((key, value) {
      if (value == 'uuid()') {
        uuidFields.add(key);
      } else {
        regularFields.add(key);
        values.add(value);
      }
    });

    // Generate column names
    final allColumns = [...uuidFields, ...regularFields];
    final columns = allColumns.join(', ');

    // Generate placeholders
    final uuidPlaceholders = uuidFields.map((_) => 'uuid()').join(', ');
    final regularPlaceholders = regularFields.map((_) => '?').join(', ');
    final allPlaceholders = [
      if (uuidPlaceholders.isNotEmpty) uuidPlaceholders,
      if (regularPlaceholders.isNotEmpty) regularPlaceholders,
    ].join(', ');

    // Construct the SQL query
    var sql = 'INSERT INTO $tableName ($columns) VALUES ($allPlaceholders)';
    if (returningClause != null) {
      sql += ' RETURNING $returningClause';
    }

    // Execute the query
    final List<dynamic> result = await db.execute(sql, values);

    // Return the first row if RETURNING clause was used, otherwise an empty map
    return result.isNotEmpty ? result.first : {};
  }

  static void backUpPowerSync() async {
    final products = ProxyService.realm.realm!.all<Product>();

    for (Product product in products) {
      try {
        final productExist = await db.getOptional(
            'SELECT *  FROM products WHERE product_id = ?', [product.id]);
        final userUuid = getUserId();
        Map<String, dynamic> map = product.toEJson().toFlipperJson();
        map['id'] = 'uuid()';
        map['product_id'] = product.id;
        map['owner_id'] = userUuid;
        map.remove('_id');
        map.remove('composites');

        if (productExist == null) {
          await genericInsert(
            tableName: 'products',
            data: map,
            returningClause: '*',
          );
        }
      } catch (e) {
        rethrow;
      }
    }
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

  Duration _downloadFileSchele() {
    return Duration(minutes: kDebugMode ? 1 : 2);
  }

  Duration _getBackUpDuration() {
    return Duration(hours: kDebugMode ? 8 : 10);
  }

  Duration _getHeartBeatDuration() {
    return Duration(seconds: kDebugMode ? 20 : 60);
  }
}
