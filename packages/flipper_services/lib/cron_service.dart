import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firestore_models/firestore_models.dart' as odm;

class CronService {
  final drive = GoogleDrive();
  bool doneInitializingDataPull = false;

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
    await ProxyService.strategy.spawnIsolate(IsolateHandler.handler);
    Timer.periodic(Duration(minutes: 10), (Timer t) async {
      final URI = await ProxyService.box.getServerUrl();
      final tinNumber = ProxyService.box.tin();
      final bhfId = await ProxyService.box.bhfId();
      final branchId = ProxyService.box.getBranchId()!;
      PatchTransactionItem.patchTransactionItem(
        URI: URI!,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
        tinNumber: tinNumber,
        bhfId: bhfId!,
      );
      StockPatch.patchStock(
        URI: URI,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );

      VariantPatch.patchVariant(
        URI: URI,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );

      CustomerPatch.patchCustomer(
        URI: URI,
        tinNumber: tinNumber,
        bhfId: bhfId,
        branchId: branchId,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
    });
    Timer.periodic(Duration(seconds: 40), (Timer t) async {
      if (ProxyService.strategy.sendPort != null) {
        try {
          ProxyService.strategy.sendMessageToIsolate();
        } catch (e) {
          talker.error(e);
        }
      }
    });
    ProxyService.box.remove(key: "customPhoneNumberForPayment");
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();

    await ProxyService.strategy.configureCapella(
      useInMemory: false,
      box: ProxyService.box,
    );
    ProxyService.strategy.startReplicator();
    if (Platform.isWindows) {
      ProxyService.setStrategy(Strategy.bricks);
      ProxyService.strategy.whoAmI();
    } else {
      ProxyService.setStrategy(Strategy.bricks);
      ProxyService.strategy.whoAmI();
    }
    final counter = await ProxyService.strategy.getCounters(branchId: 1);
    talker.warning("GET COUNTER FROM STRATEGY: ${counter.length}");

    // AsyncCollection? collection = await ProxyService
    //     .capela.capella?.flipperDatabase!
    //     .collection(countersTable, 'user_data');
    // if (collection == null) {
    //   collection = await ProxyService.capela.capella?.flipperDatabase!
    //       .createCollection(countersTable, "default");
    // }
    // // counters
    // List<Counter> counters = ProxyService.strategy.realm!.all<Counter>().toList();
    // for (Counter counter in counters) {
    //   print("counter: ${counter.id}");
    //   final document = odm.Counter(
    //     id: counter.id,
    //     businessId: counter.businessId,
    //     branchId: counter.branchId,
    //     receiptType: counter.receiptType,
    //     totRcptNo: counter.totRcptNo,
    //     curRcptNo: counter.curRcptNo,
    //     invcNo: counter.invcNo,
    //     lastTouched: counter.lastTouched,
    //   );
    //   await ProxyService.capela.capella?.flipperDatabase!.writeN(
    //       tableName: countersTable,
    //       writeCallback: () {
    //         return MutableDocument.withId(
    //             counter.id.toString(), document.toJson());
    //       },
    //       onAdd: (doc) async {
    //         await collection!.saveDocument(doc);
    //         print("Document saved: ${doc.id}");
    //       });
    // }
    ProxyService.strategy
        .getPaymentPlan(businessId: ProxyService.box.getBusinessId()!);
    if (results.any((result) => result != ConnectivityResult.none)) {
      if (FirebaseAuth.instance.currentUser == null) {
        await ProxyService.strategy.firebaseLogin();
      }
      talker.warning("Done checking connectivity: $doneInitializingDataPull");
      if (!doneInitializingDataPull) {
        talker.warning("Starting pull change");

        doneInitializingDataPull = true;
      }
    }

    ProxyService.box.writeBool(key: 'isOrdering', value: false);

    if (ProxyService.box.forceUPSERT()) {
      // ProxyService.strategy.upSert();
      ProxyService.strategy.startReplicator();
    }

    Timer.periodic(_downloadFileSchedule(), (Timer t) {
      if (!ProxyService.box.doneDownloadingAsset()) {
        ProxyService.strategy.reDownloadAsset();
      }
    });
    await _setupFirebaseMessaging();

    talker.warning("Done cleaning up variants");
  }

  static String camelToSnakeCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match match) => '_${match.group(1)!.toLowerCase()}',
    );
  }

  Future<void> _setupFirebaseMessaging() async {
    Business? business = await ProxyService.strategy.getBusiness();
    String? token;

    if (!Platform.isWindows && !isMacOs && !isIos) {
      token = await FirebaseMessaging.instance.getToken();

      business!.deviceToken = token.toString();
    }
  }

  Duration _downloadFileSchedule() {
    return Duration(minutes: kDebugMode ? 1 : 2);
  }
}
