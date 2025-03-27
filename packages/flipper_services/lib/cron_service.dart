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
    /// when app start load data to keep stock up to date and everything.
    /// because this might override data offline if it where not synced this should be used
    /// with caution, only do it if we are forcing upsert.
    if (await ProxyService.strategy.queueLength() == 0) {
      talker.warning("We got empty Queue we can hydrate the data");
      ProxyService.strategy
          .ebm(branchId: ProxyService.box.getBranchId()!, fetchRemote: true);
      ProxyService.strategy.getCounters(
          branchId: ProxyService.box.getBranchId()!, fetchRemote: true);
      ProxyService.strategy.variants(
          branchId: ProxyService.box.getBranchId()!, fetchRemote: true);
    }

    if (ProxyService.box.forceUPSERT()) {
      ProxyService.strategy.variants(
          branchId: ProxyService.box.getBranchId()!, fetchRemote: true);
    }

    /// end of pulling
    await ProxyService.strategy.spawnIsolate(IsolateHandler.handler);

    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      ProxyService.strategy
          .getCounters(branchId: ProxyService.box.getBranchId()!);
    });
    Timer.periodic(Duration(seconds: kDebugMode ? 40 : 40), (Timer t) async {
      if (ProxyService.strategy.sendPort != null) {
        try {
          ProxyService.strategy.sendMessageToIsolate();
        } catch (e) {
          talker.error(e);
        }
      }
    });
    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      ProxyService.strategy
          .analytics(branchId: ProxyService.box.getBranchId()!);
      final isTaxServiceStoped = ProxyService.box.stopTaxService();
      if (!ProxyService.box.transactionInProgress() && !isTaxServiceStoped!) {
        final URI = await ProxyService.box.getServerUrl();

        //// first check if there is no other transaction in progress before we start the patching
        if (!ProxyService.box.lockPatching()) {
          await VariantPatch.patchVariant(
            URI: URI!,
            sendPort: (message) {
              ProxyService.notification.sendLocalNotification(body: message);
            },
          );
          final tinNumber = ProxyService.box.tin();
          final bhfId = await ProxyService.box.bhfId();
          await PatchTransactionItem.patchTransactionItem(
            tinNumber: tinNumber,
            bhfId: bhfId!,
            URI: URI,
            sendPort: (message) {
              ProxyService.notification.sendLocalNotification(body: message);
            },
          );
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

    ProxyService.strategy
        .getPaymentPlan(businessId: ProxyService.box.getBusinessId()!);
    if (results.any((result) => result != ConnectivityResult.none)) {
      if (!isTestEnvironment() && FirebaseAuth.instance.currentUser == null) {
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

  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
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

    if (!Platform.isWindows && !isMacOs && !isIos && business != null) {
      token = await FirebaseMessaging.instance.getToken();

      business.deviceToken = token.toString();
    }
  }

  Duration _downloadFileSchedule() {
    return Duration(minutes: kDebugMode ? 1 : 2);
  }
}
