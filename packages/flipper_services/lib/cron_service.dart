import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/PullChange.dart';
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
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();

    if (results.any((result) => result != ConnectivityResult.none)) {
      if (FirebaseAuth.instance.currentUser == null) {
        await ProxyService.synchronize.firebaseLogin();
      }
      talker.warning("Done checking connectivity: $doneInitializingDataPull");
      if (!doneInitializingDataPull) {
        talker.warning("Starting pull change");
        PullChange().start(
          mbranchId: ProxyService.box.getBranchId()!,
          mbusinessId: ProxyService.box.getBusinessId()!,
          muserId: ProxyService.box.getUserId()!,
          firestore: FirebaseFirestore.instance,
          localRealm: ProxyService.local.realm!,
        );
        doneInitializingDataPull = true;
      }
    }

    ProxyService.box.writeBool(key: 'isOrdering', value: false);

    if (ProxyService.box.forceUPSERT()) {
      ProxyService.local.upSert();
    }

    await ProxyService.local.spawnIsolate(IsolateHandler.handler);

    Timer.periodic(Duration(seconds: 40), (Timer t) async {
      if (ProxyService.box.getUserId() == null ||
          ProxyService.box.getBusinessId() == null) return;

      if (ProxyService.local.sendPort != null) {
        ProxyService.local.sendMessageToIsolate();
      }
    });

    Timer.periodic(_downloadFileSchedule(), (Timer t) {
      if (!ProxyService.box.doneDownloadingAsset()) {
        ProxyService.local.reDownloadAsset();
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
    Business? business = await ProxyService.local.getBusiness();
    String? token;

    if (!Platform.isWindows && !isMacOs && !isIos) {
      token = await FirebaseMessaging.instance.getToken();

      Map updatedBusiness = business.toEJson() as Map<String, dynamic>;
      updatedBusiness['deviceToken'] = token.toString();
    }
  }

  Duration _downloadFileSchedule() {
    return Duration(minutes: kDebugMode ? 1 : 2);
  }
}
