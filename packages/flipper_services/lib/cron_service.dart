import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_services/PullChange.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/DownloadQueue.dart';
import 'package:flipper_models/CloudSync.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CronService {
  final drive = GoogleDrive();
  bool doneInitializingDataPull = false;
  SendPort? sendPort;
  ReceivePort? receivePort;

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
      if (!doneInitializingDataPull) {
        PullChange().start(
          mbranchId: ProxyService.box.getBranchId()!,
          mbusinessId: ProxyService.box.getBusinessId()!,
          muserId: ProxyService.box.getUserId()!,
          firestore: FirebaseFirestore.instance,
          localRealm: ProxyService.local.realm!,
        );
        // doneInitializingDataPull = true;
      }
    }

    ProxyService.box.writeBool(key: 'isOrdering', value: false);

    if (ProxyService.box.forceUPSERT()) {
      try {
        /// get all Products
        List<Product> products =
            ProxyService.local.realm!.all<Product>().toList();
        for (Product product in products) {
          ProxyService.synchronize.updateRecord(
              tableName: productsTable,
              idField: "${productsTable.singularize()}_id",
              map: product.toEJson().toFlipperJson(),
              id: product.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }
        List<Assets> assets = ProxyService.local.realm!.all<Assets>().toList();
        for (Assets asset in assets) {
          ProxyService.synchronize.updateRecord(
              tableName: assetsTable,
              idField: "${assetsTable.singularize()}_id",
              map: asset.toEJson().toFlipperJson(),
              id: asset.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }

        List<Variant> variants =
            ProxyService.local.realm!.all<Variant>().toList();
        for (Variant variant in variants) {
          ProxyService.synchronize.updateRecord(
              tableName: variantTable,
              idField: "${variantTable.singularize()}_id",
              map: variant.toEJson().toFlipperJson(),
              id: variant.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }

        List<Stock> stocks = ProxyService.local.realm!.all<Stock>().toList();
        for (Stock stock in stocks) {
          ProxyService.synchronize.updateRecord(
              tableName: stocksTable,
              idField: "${stocksTable.singularize()}_id",
              map: stock.toEJson(includeVariant: true).toFlipperJson(),
              id: stock.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }

        List<TransactionItem> items =
            ProxyService.local.realm!.all<TransactionItem>().toList();
        for (TransactionItem item in items) {
          ProxyService.synchronize.updateRecord(
              tableName: transactionItemsTable,
              idField: "${transactionItemsTable.singularize()}_id",
              map: item.toEJson().toFlipperJson(),
              id: item.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }

        List<Access> accesses =
            ProxyService.local.realm!.all<Access>().toList();
        for (Access access in accesses) {
          ProxyService.synchronize.updateRecord(
              tableName: accessesTable,
              idField: "${accessesTable.singularize()}_id",
              map: access.toEJson().toFlipperJson(),
              id: access.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }
        List<StockRequest> requests =
            ProxyService.local.realm!.all<StockRequest>().toList();
        for (StockRequest request in requests) {
          ProxyService.synchronize.updateRecord(
              tableName: stockRequestsTable,
              idField: "${stockRequestsTable.singularize()}_id",
              map: request.toEJson().toFlipperJson(),
              id: request.id!,
              syncProvider: SyncProvider.FIRESTORE);
        }
      } catch (e, s) {
        talker.warning(e);
        talker.error(s);
      }
    }

    // CloudSync(firestore, realm).deleteDuplicate(tableName: productsTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: variantTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: stocksTable);
    // CloudSync(firestore, realm)
    //     .deleteDuplicate(tableName: transactionItemsTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: stockRequestsTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: accessesTable);
    // CloudSync(firestore, realm)
    //     .deleteDuplicate(tableName: transactionItemsTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: assetsTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: categoriesTable);

    // CloudSync(firestore, realm).deleteDuplicate(tableName: customersTable);
    // CloudSync(firestore, realm).deleteDuplicate(tableName: devicesTable);

    /// start isolate

    await _spawnIsolate(IsolateHandler.handler);

    Timer.periodic(Duration(seconds: 40), (Timer t) async {
      if (ProxyService.box.getUserId() == null ||
          ProxyService.box.getBusinessId() == null) return;

      if (sendPort != null) {
        Business business = ProxyService.local.realm!.query<Business>(
            r'serverId == $0', [ProxyService.box.getBusinessId()!]).first;
        sendPort!.send({
          'task': 'sync',
          'branchId': ProxyService.box.getBranchId()!,
          "URI": ProxyService.box.getServerUrl(),
          "userId": ProxyService.box.getUserId()!,
          "businessId": ProxyService.box.getBusinessId()!,
          'encryptionKey': ProxyService.box.encryptionKey(),
          'dbPath': await ProxyService.local.dbPath(
            path: 'local',
            folder: ProxyService.box.getBusinessId(),
          ),
        });
        sendPort!.send({
          'task': 'taxService',
          'branchId': ProxyService.box.getBranchId()!,
          "URI": ProxyService.box.getServerUrl(),
          "bhfId": ProxyService.box.bhfId(),
          'tinNumber': business.tinNumber,
          'encryptionKey': ProxyService.box.encryptionKey(),
          'dbPath': await ProxyService.local.dbPath(
            path: 'local',
            folder: ProxyService.box.getBusinessId(),
          ),
        });
      }
    });

    // create a compute function to keep track of unsaved data back to EBM do this in background
    /// keep assets downloaded and saved locally as they are added by other users in same business/branch
    Timer.periodic(_downloadFileSchedule(), (Timer t) async {
      try {
        final downloadQueue = DownloadQueue(3);

        int? branchId = ProxyService.box.getBranchId();
        if (ProxyService.local.realm == null || branchId == null) {
          talker.warning("realm is null");
          return;
        }
        // ProxyService.box.writeBool(key: 'doneDownloadingAsset', value: false);
        if (!ProxyService.box.doneDownloadingAsset()) {
          List<Assets> assets = ProxyService.local.realm!
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
    await _setupFirebaseMessaging();
  }

  Future<void> _spawnIsolate(dynamic isolateHandler) async {
    if (ProxyService.box.getBusinessId() == null) return;
    try {
      if (ProxyService.local.realm == null) return;

      if (ProxyService.local
          .isTaxEnabled(business: ProxyService.local.getBusiness())) {
        // 1. Create the ReceivePort to receive messages from the isolate
        receivePort = ReceivePort();

        // 2. Spawn the isolate and pass the receivePort.sendPort to it
        // await Isolate.spawn(isolateHandler, receivePort!.sendPort);
        final rootIsolateToken = RootIsolateToken.instance!;

        await Isolate.spawn(
          isolateHandler,
          [receivePort!.sendPort, rootIsolateToken],
          debugName: 'backgroundIsolate',
        );

        // 3. Retrieve the SendPort sent back by the isolate (used to send messages to the isolate)
        // sendPort = await receivePort!.first;

        receivePort!.listen(
          (message) async {
            if (message is SendPort) {
              // Store the sendPort for communication with isolate
              sendPort = message;
              print('SendPort received');
            }
            String identifier = message as String;
            List<String> separator = identifier.split(":");

            if (separator.first == "notification") {
              if (separator.length == 2) {
                /// this is error message
                ProxyService.notification
                    .sendLocalNotification(body: separator[1]);
              }
              if (separator.length < 3) return;
              if (separator[2] == "variant") {
                final variantId = int.tryParse(separator[3]);
                Variant? variant =
                    ProxyService.local.variant(variantId: variantId);
                if (variant != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: variantTable,
                    writeCallback: () {
                      variant.ebmSynced = true;
                      return variant;
                    },
                    onAdd: (data) {
                      ProxyService.synchronize
                          .syncToFirestore(variantTable, data);
                    },
                  );
                }
                ProxyService.notification
                    .sendLocalNotification(body: "Item Saving " + separator[1]);
              }
              if (separator[2] == "stock") {
                final stockId = int.tryParse(separator[3]);
                Stock? stock = ProxyService.local.getStockById(id: stockId!);
                if (stock != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: stocksTable,
                    writeCallback: () {
                      stock.ebmSynced = true;
                      return stock;
                    },
                    onAdd: (data) {
                      ProxyService.synchronize
                          .syncToFirestore(stocksTable, data);
                    },
                  );
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Stock Saving " + separator[1]);
              }
              if (separator[2] == "customer") {
                final customerId = int.tryParse(separator[3]);
                Customer? customer =
                    ProxyService.local.getCustomer(id: customerId);
                if (customer != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: customersTable,
                    writeCallback: () {
                      customer.ebmSynced = true;
                      return customer;
                    },
                    onAdd: (data) {
                      ProxyService.synchronize
                          .syncToFirestore(customersTable, data);
                    },
                  );
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Customer Saving " + separator[1]);
              }
              if (separator[2] == "transaction") {
                final transactionId = int.tryParse(separator[3]);
                ITransaction? transaction =
                    ProxyService.local.getTransactionById(id: transactionId!);
                if (transaction != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: transactionTable,
                    writeCallback: () {
                      transaction.ebmSynced = true;
                      return transaction;
                    },
                    onAdd: (data) {
                      ProxyService.synchronize
                          .syncToFirestore(transactionTable, data);
                    },
                  );
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Transaction Saving " + separator[1]);
              }
            }
          },
        );
      }
    } catch (error, s) {
      talker.warning('Error managing isolates: $error');
      talker.warning('Error managing isolates: $s');
    }
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
