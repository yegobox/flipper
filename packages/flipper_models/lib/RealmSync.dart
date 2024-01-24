// ignore: unused_import
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'dart:isolate';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/realm/realmIUnit.dart';
import 'package:flipper_models/realm/realmProduct.dart';
import 'package:flipper_models/realm/realmVariant.dart';
import 'package:flipper_models/realm/realmStock.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'remote_service.dart';
import 'sync.dart';
import 'package:realm/realm.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';

abstract class SyncReaml<M extends IJsonSerializable> implements Sync {
  Future<void> onSave<T extends IJsonSerializable>({required T item});
  factory SyncReaml.create() => RealmSync<M>();
  Future<Realm> configure();
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments);
  Future<void> heartBeat();
  void close();
}

class RealmSync<M extends IJsonSerializable>
    with HandleItemMixin
    implements SyncReaml<M> {
  late Realm realm;
  Future<String> absolutePath(String fileName) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final realmDirectory = '${appDocsDirectory.path}/flipper-sync';
    if (!Directory(realmDirectory).existsSync()) {
      await Directory(realmDirectory).create(recursive: true);
    }
    return "$realmDirectory/$fileName";
  }

  @override
  Future<Realm> configure() async {
    log(ProxyService.box.encryptionKey(), name: 'encriptionKey');
    int? branchId = ProxyService.box.getBranchId();

    //NOTE: https://www.mongodb.com/docs/atlas/app-services/domain-migration/
    final app = App(AppConfiguration(AppSecrets.appId,
        baseUrl: Uri.parse("https://services.cloud.mongodb.com")));
    final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
    List<int> key = ProxyService.box.encryptionKey().toIntList();
    final config = Configuration.flexibleSync(
        user,
        [
          RealmITransaction.schema,
          RealmITransactionItem.schema,
          RealmProduct.schema,
          RealmVariant.schema,
          RealmStock.schema,
          RealmIUnit.schema
        ],
        // encryptionKey:key,
        path: await absolutePath("db_"),
        clientResetHandler: RecoverUnsyncedChangesHandler(
      onBeforeReset: (beforeResetRealm) {
        log("reset requested here..");

        ///which the SDK invokes prior to the client reset.
        ///You can use this callback to notify the user before the reset begins.
      },
    ), shouldCompactCallback: ((totalSize, usedSize) {
      // Compact if the file is over 10MB in size and less than 50% 'used'
      const tenMB = 10 * 1048576;
      return (totalSize > tenMB) &&
          (usedSize.toDouble() / totalSize.toDouble()) < 0.5;
    }));
    // realm = await Realm.open(config);
    CancellationToken token = CancellationToken();

    // Cancel the open operation after 30 seconds.
    // Alternatively, you could display a loading dialog and bind the cancellation
    // to a button the user can click to stop the wait.
    Future<void>.delayed(
      const Duration(seconds: 30),
      () => token.cancel(
        CancelledException(
          cancellationReason: "Realm took too long to open",
        ),
      ),
    );

    // If realm does not open after 30 seconds with asynchronous Realm.open(),
    // open realm immediately with Realm() and try to sync data in the background.

    try {
      realm = Realm(config);
      // realm = await Realm.open(config, cancellationToken: token,
      //     onProgressCallback: (syncProgress) {
      //   if (syncProgress.transferableBytes == syncProgress.transferredBytes) {
      //     print('All bytes transferred!');
      //   }
      // });
    } catch (e) {
      print(e);
      realm = Realm(config);
    }

    updateSubscription(branchId);

    /// removed await on bellow line because when it is in bootstrap, it might freeze the app
    await realm.subscriptions.waitForSynchronization();
    return realm;
  }

  void updateSubscription(int? branchId) {
    final transaction =
        realm.query<RealmITransaction>(r'branchId == $0', [branchId]);
    final transactionItem =
        realm.query<RealmITransactionItem>(r'branchId == $0', [branchId]);
    final product = realm.query<RealmProduct>(r'branchId == $0', [branchId]);
    final variant = realm.query<RealmVariant>(r'branchId == $0', [branchId]);
    final stock = realm.query<RealmStock>(r'branchId == $0', [branchId]);
    final unit = realm.query<RealmIUnit>(r'branchId == $0', [branchId]);
    //https://www.mongodb.com/docs/realm/sdk/flutter/sync/manage-sync-subscriptions/
    realm.subscriptions.update((sub) {
      sub.clear();
      sub.add(transaction, name: "transactions-${branchId}", update: true);
      sub.add(transactionItem,
          name: "transactionItems-${branchId}", update: true);
      sub.add(product, name: "iProduct-${branchId}", update: true);
      sub.add(variant, name: "iVariant-${branchId}", update: true);
      sub.add(stock, name: "iStock-${branchId}", update: true);
      sub.add(unit, name: "iUnit-${branchId}", update: true);
    });
  }

  @override
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments) {
    final results = realm.query<T>(query, arguments);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  @override
  Future<void> localChanges() {
    // TODO: implement localChanges
    throw UnimplementedError();
  }

  @override
  Future<void> onSave<T extends IJsonSerializable>({required T item}) async {
    //TODO: when action is updated_locally do not do anything but wait for a 1 week to introduce the changes
    // before the system full get all defaulted update on devices

    if (item is ITransaction) {
      // Save _RealmITransaction to the Realm database
      if (item.action == AppActions.synchronized) return;
      realm.write(() {
        final realmITransaction = RealmITransaction(
          item.id,
          ObjectId(),
          item.reference,
          item.transactionNumber,
          item.branchId,
          item.status,
          item.transactionType,
          item.subTotal,
          item.paymentType,
          item.cashReceived,
          item.customerChangeDue,
          item.createdAt,
          item.action,
          categoryId: item.categoryId,
          customerId: item.customerId,
          deletedAt: item.deletedAt,
          lastTouched: item.lastTouched,
          note: item.note,
          receiptType: item.receiptType,
          supplierId: item.supplierId,
          ticketName: item.ticketName,
          updatedAt: item.updatedAt,
        );
        final findableObject =
            realm.query<RealmITransaction>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm.add(realmITransaction);
        } else {
          RealmITransaction existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmITransaction);
        }
      });
    }

    if (item is TransactionItem) {
      // Save _RealmITransaction to the Realm database
      if (item.action == AppActions.synchronized) return;
      realm.write(() {
        final realmITransactionItem = RealmITransactionItem(
          ObjectId(),
          item.name,
          item.transactionId,
          item.variantId,
          item.qty,
          item.price,
          item.action,
          item.branchId,
          item.remainingStock,
          item.createdAt,
          item.id,
          item.updatedAt,
          item.isTaxExempted,
          addInfo: item.addInfo,
          deletedAt: item.deletedAt,
          lastTouched: item.lastTouched,
          bcd: item.bcd,
          bhfId: item.bhfId,
          dcAmt: item.dcAmt,
          dcRt: item.dcRt,
          dftPrc: item.dftPrc,
          discount: item.discount,
          doneWithTransaction: item.doneWithTransaction,
          isRefunded: item.isRefunded,
          isrcAmt: item.isrcAmt,
          isrcAplcbYn: item.isrcAplcbYn,
          isrcRt: item.isrcRt,
          isrccCd: item.isrccCd,
          isrccNm: item.isrccNm,
          itemCd: item.itemCd,
          itemClsCd: item.itemClsCd,
          itemNm: item.itemNm,
          itemSeq: item.itemSeq,
          itemStdNm: item.itemStdNm,
          itemTyCd: item.itemTyCd,
          modrId: item.modrId,
          modrNm: item.modrNm,
          orgnNatCd: item.orgnNatCd,
          pkg: item.pkg,
          pkgUnitCd: item.pkgUnitCd,
          prc: item.prc,
          qtyUnitCd: item.qtyUnitCd,
          regrId: item.regrId,
          regrNm: item.regrNm,
          splyAmt: item.splyAmt,
          taxAmt: item.taxAmt,
          taxTyCd: item.taxTyCd,
          taxblAmt: item.taxAmt,
          tin: item.tin,
          totAmt: item.totAmt,
          type: item.type,
          useYn: item.useYn,
        );
        final findableObject =
            realm.query<RealmITransactionItem>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm.add(realmITransactionItem);
        } else {
          RealmITransactionItem existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmITransactionItem);
        }
      });
    }
    if (item is Product) {
      /// there is cases where more than one device is editing the temp product
      /// this is when a product is in creation mode and not yet done, when this is synced to the
      /// cloud then other user might start editting the same product which is edited by another user
      /// to handle that case then we simply do not send this product to the cloud to make sure the user edit the product that he/she owns at
      /// the moment of creation
      if (item.name == TEMP_PRODUCT) return;
      if (item.action == AppActions.synchronized) return;
      realm.write(() {
        final realmProduct = RealmProduct(
          item.id,
          ObjectId(), // Auto-generate ObjectId for realmId
          item.name,
          item.color,
          item.businessId,
          item.branchId,
          item.action,
          description: item.description,
          taxId: item.taxId,
          supplierId: item.supplierId,
          categoryId: item.categoryId,
          createdAt: item.createdAt,
          unit: item.unit,
          imageUrl: item.imageUrl,
          expiryDate: item.expiryDate,
          barCode: item.barCode,
          nfcEnabled: item.nfcEnabled,
          bindedToTenantId: item.bindedToTenantId,
          deletedAt: item.deletedAt,
          isFavorite: item.isFavorite,
          lastTouched: item.lastTouched, // Update lastTouched timestamp
        );
        final findableObject =
            realm.query<RealmProduct>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm.add(realmProduct);
        } else {
          RealmProduct existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmProduct);
        }
      });
    }
    if (item is Variant) {
      if (item.action == AppActions.synchronized) return;
      realm.write(() {
        final realmVariant = RealmVariant(
          ObjectId(), // Auto-generate ObjectId for realmId
          item.name,
          item.color,
          item.sku,
          item.productId,
          item.unit,
          item.productName,
          item.branchId,
          item.isTaxExempted,
          item.action,
          item.id,
          item.retailPrice,
          item.supplyPrice,
          dftPrc: item.dftPrc,
          taxName: item.taxName,
          taxPercentage: item.taxPercentage,
          isrcAplcbYn: item.isrcAplcbYn,
          modrId: item.modrId,
          rsdQty: item.rsdQty,
          taxTyCd: item.taxTyCd,
          bcd: item.bcd,
          itemClsCd: item.itemClsCd,
          itemTyCd: item.itemTyCd,
          itemStdNm: item.itemStdNm,
          addInfo: item.addInfo,
          pkg: item.pkg,
          useYn: item.useYn,
          regrNm: item.regrNm,
          modrNm: item.modrNm,
          itemNm: item.itemNm,
          lastTouched: item.lastTouched,
          deletedAt: item.deletedAt,
          tin: item.tin,
          bhfId: item.bhfId,
          regrId: item.regrId,
          orgnNatCd: item.orgnNatCd,
          itemSeq: item.itemSeq,
          itemCd: item.itemCd,
          isrccCd: item.isrccCd,
          pkgUnitCd: item.pkgUnitCd,
          qtyUnitCd: item.qtyUnitCd,
          isrccNm: item.isrccNm,
          qty: item.qty,
          isrcRt: item.isrcRt,
          prc: item.prc,
          isrcAmt: item.isrcAmt,
          splyAmt: item.splyAmt,
        );
        final findableObject =
            realm.query<RealmVariant>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Variant doesn't exist, add it
          realm.add(realmVariant);
        } else {
          RealmVariant existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmVariant);
        }
      });
    }
    if (item is Stock) {
      if (item.action == AppActions.synchronized) return;
      realm.write(() {
        final realmStock = RealmStock(
          item.id,
          ObjectId(), // Auto-generate ObjectId for realmId
          item.branchId,
          item.variantId,
          item.currentStock,
          item.productId,
          item.action,
          lowStock: item.lowStock,
          canTrackingStock: item.canTrackingStock,
          showLowStockAlert: item.showLowStockAlert,
          active: item.active,
          value: item.value,
          rsdQty: item.rsdQty,
          supplyPrice: item.supplyPrice,
          retailPrice: item.retailPrice,
          lastTouched: item.lastTouched,
          deletedAt: item.deletedAt,
        );
        final findableObject = realm.query<RealmStock>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Stock doesn't exist, add it
          realm.add(realmStock);
        } else {
          // Stock exists, update it
          RealmStock existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmStock);
        }
      });
    }
    if (item is IUnit) {
      if (item.action == AppActions.synchronized) return;
      realm.write(() {
        IUnit data = item;
        final realmUnit = RealmIUnit(
          ObjectId(),
          data.id, // Auto-generate ObjectId for realmId
          data.branchId,
          data.name,
          data.value,
          data.active,
        );

        final findableObject = realm.query<RealmIUnit>(r'id == $0', [data.id]);

        if (findableObject.isEmpty) {
          // Unit doesn't exist, add it
          realm.add(realmUnit);
        } else {
          // Unit exists, update it
          RealmIUnit existingUnit = findableObject.first;

          existingUnit.updateProperties(realmUnit);
        }
      });
    }
    // realm.close();
  }

  @override
  Future<void> pull() async {
    RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
    int branchId = ProxyService.box.getBranchId()!;
    String key = ProxyService.box.encryptionKey();
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(IsolateHandler.handleRealm, [
      rootIsolateToken,
      receivePort.sendPort,
      branchId,
      key,
    ]);
    receivePort.listen((message) {
      log('Isolate: $message');
    });
  }

  @override
  Future<void> push() {
    // TODO: implement push
    throw UnimplementedError();
  }

  /// an experimental to call the mongo db api directly via api
  /// to get changes as subscribing to the change is not getting
  /// data to the device in time we think!
  Future<void> heartBeat() async {
    log('calling heart beat');
    int branchId = ProxyService.box.getBranchId()!;
    var headers = {
      'api-key': AppSecrets.mongoApiSecret,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AppSecrets.mongoEndPoint));
    request.body = json.encode({
      "collection": "RealmITransaction",
      "database": "flipper",
      "dataSource": "Cluster0",
      "filter": {"branchId": branchId},
      "sort": {"createdAt": -1}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Decode the response stream into a string
      String jsonString = await response.stream.bytesToString();

      // Parse the JSON string into a map
      Map<String, dynamic> jsonResponse = json.decode(jsonString);

      // Access the "documents" key and convert each map to an ITransaction object
      if (jsonResponse.containsKey("documents")) {
        List<Map<String, dynamic>> jsonList =
            List.from(jsonResponse["documents"]);

        List<ITransaction> transactions =
            jsonList.map((jsonMap) => ITransaction.fromJson(jsonMap)).toList();

        // Now you can manipulate the data in the 'transactions' list
        for (var transaction in transactions) {
          // Do something with each transaction
          print(transaction.reference);
          ITransaction? local =
              await ProxyService.isar.getTransactionById(id: transaction.id);
          if (local != null) {
            Conversation conversation = Conversation.notificaton(
                userName: ProxyService.box.getUserPhone()!,
                body: "Received new  sale: ${transaction.subTotal}-RWF",
                id: transaction.id);
            await NotificationsCubit.instance
                .scheduleNotification(conversation);
            local = local.copyWith(
                reference: transaction.reference,
                categoryId: transaction.categoryId,
                transactionNumber: transaction.transactionNumber,
                subTotal: transaction.subTotal,
                cashReceived: transaction.cashReceived,
                lastTouched: transaction.lastTouched);
            await ProxyService.isar.update(data: local, localUpdate: true);
          } else {
            Conversation conversation = Conversation.notificaton(
                userName: ProxyService.box.getUserPhone()!,
                body: "Received new  sale: ${transaction.subTotal}-RWF",
                id: transaction.id);
            await NotificationsCubit.instance
                .scheduleNotification(conversation);
            await ProxyService.isar.create(data: transaction);
          }
        }
      } else {
        print("No 'documents' key found in the response.");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void close() {
    realm.close();
  }
}
