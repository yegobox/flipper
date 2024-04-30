// ignore: unused_import
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realm/realmCounter.dart';
import 'package:flipper_models/realm/realmCustomer.dart';
import 'package:flipper_models/realm/realmReceipt.dart';
import 'package:flipper_models/realmModels.dart';
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
  Future<bool> logout();
}

class RealmSync<M extends IJsonSerializable>
    with HandleItemMixin
    implements SyncReaml<M>, IsarApiInterface {
  Realm? realm;
  Future<String> absolutePath(String fileName) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final int businessId = ProxyService.box.getBusinessId()!;
    final int branchId = ProxyService.box.getBranchId()!;
    final realmDirectory = '${appDocsDirectory.path}/flipper-' +
        branchId.toString() +
        "_" +
        businessId.toString();

    // Create the new directory
    await Directory(realmDirectory).create(recursive: true);

    return "$realmDirectory/$fileName";
  }

  @override
  Future<Realm> configure() async {
    int? branchId = ProxyService.box.getBranchId();
    if (realm != null) {
      return realm!;
    }

    //NOTE: https://www.mongodb.com/docs/atlas/app-services/domain-migration/
    final app = App(AppConfiguration(AppSecrets.appId,
        baseUrl: Uri.parse("https://services.cloud.mongodb.com")));
    final user = app.currentUser ??
        await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));

    String path = await absolutePath("db_");

    List<int> key = ProxyService.box.encryptionKey().toIntList();
    final config = Configuration.flexibleSync(
      user,
      realmModels,
      encryptionKey: key,
      path: path,
      clientResetHandler: RecoverUnsyncedChangesHandler(
        onBeforeReset: (beforeResetRealm) {
          log("reset requested here..");

          ///which the SDK invokes prior to the client reset.
          ///You can use this callback to notify the user before the reset begins.
        },
      ),
      shouldCompactCallback: ((totalSize, usedSize) {
        // Compact if the file is over 10MB in size and less than 50% 'used'
        const tenMB = 10 * 1048576;
        return (totalSize > tenMB) &&
            (usedSize.toDouble() / totalSize.toDouble()) < 0.5;
      }),
    );
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
      //  realm = Realm(config);
      realm = await Realm.open(config, cancellationToken: token,
          onProgressCallback: (syncProgress) {
        if (syncProgress.progressEstimate == 1.0) {
          print('All bytes transferred!');
        }
      });
      log("Opened realm[1]", name: "OpeningRealm");
    } catch (e) {
      log("Opened realm[2]", name: "OpeningRealm");
      print(e);
      // realm = Realm(config);
    }
    // Realm.logger.level = RealmLogLevel.trace;
    await updateSubscription(branchId);

    /// removed await on bellow line because when it is in bootstrap, it might freeze the app
    await realm?.subscriptions.waitForSynchronization();
    // realm?.refresh();
    return realm!;
  }

  Future<void> updateSubscription(int? branchId) async {
    if (realm == null) return;
    final transactionItem =
        realm!.query<RealmITransactionItem>(r'branchId == $0', [branchId]);
    final product = realm!.query<RealmProduct>(r'branchId == $0', [branchId]);
    final variant = realm!.query<RealmVariant>(r'branchId == $0', [branchId]);
    final stock = realm!.query<RealmStock>(r'branchId == $0', [branchId]);
    final unit = realm!.query<RealmIUnit>(r'branchId == $0', [branchId]);
    final counter = realm!.query<RealmCounter>(r'branchId == $0', [branchId]);
    final receipt = realm!.query<RealmReceipt>(r'branchId == $0', [branchId]);
    final customer = realm!.query<RealmCustomer>(r'branchId == $0', [branchId]);

    final transaction =
        realm!.query<RealmITransaction>(r'branchId == $0', [branchId]);
    //https://www.mongodb.com/docs/realm/sdk/flutter/sync/manage-sync-subscriptions/

    await customer.subscribe(
        name: "iCustomer-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await receipt.subscribe(
        name: "iReceipt-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await product.subscribe(
        name: "iProduct-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await counter.subscribe(
        name: "iCounter-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await variant.subscribe(
        name: "iVariant-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await stock.subscribe(
        name: "iStock-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await unit.subscribe(
        name: "iUnit-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await transaction.subscribe(
        name: "transaction-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);
    await transactionItem.subscribe(
        name: "transactionItem-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    // realm?.subscriptions.update((sub) {
    //   // sub.clear();
    //   sub.add(transaction, name: "transactions-${branchId}", update: true);
    //   sub.add(transactionItem,
    //       name: "transactionItems-${branchId}", update: true);
    //   sub.add(product, name: "iProduct-${branchId}", update: true);
    //   sub.add(variant, name: "iVariant-${branchId}", update: true);
    //   sub.add(stock, name: "iStock-${branchId}", update: true);
    //   sub.add(unit, name: "iUnit-${branchId}", update: true);
    // });
  }

  @override
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments) {
    if (realm == null) return null;
    final results = realm!.query<T>(query, arguments);
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
    if (realm == null) return;
    if (item is ITransaction) {
      // Save _RealmITransaction to the Realm database
      if (item.action == AppActions.synchronized) return;
      realm!.write(() {
        final realmITransaction = RealmITransaction(
          item.id!,
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
          customerId: item.customerId!,
          deletedAt: item.deletedAt,
          lastTouched: item.lastTouched,
          note: item.note,
          receiptType: item.receiptType,
          supplierId: item.supplierId,
          ticketName: item.ticketName,
          updatedAt: item.updatedAt,
        );
        final findableObject =
            realm!.query<RealmITransaction>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm!.add(realmITransaction);
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
      realm!.write(() {
        final realmITransactionItem = RealmITransactionItem(
          item.id!,
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
            realm!.query<RealmITransactionItem>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm!.add(realmITransactionItem);
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
      realm!.write(() {
        final realmProduct = RealmProduct(
          item.id!,
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
            realm!.query<RealmProduct>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm!.add(realmProduct);
        } else {
          RealmProduct existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmProduct);
        }
      });
    }
    if (item is Variant) {
      if (item.action == AppActions.synchronized) return;
      realm!.write(() {
        final realmVariant = RealmVariant(
            item.id!,
            ObjectId(), // Auto-generate ObjectId for realmId
            item.name,
            item.color,
            item.sku,
            item.productId,
            item.unit,
            item.productName,
            item.branchId,
            item.isTaxExempted,
            item.supplyPrice,
            item.retailPrice,
            item.action,
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
            spplrItemCd: item.spplrItemCd,
            spplrItemNm: item.spplrItemNm,
            ebmSynced: item.ebmSynced,
            spplrItemClsCd: item.spplrItemClsCd);
        final findableObject =
            realm!.query<RealmVariant>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Variant doesn't exist, add it
          realm!.add(realmVariant);
        } else {
          RealmVariant existingTransaction = findableObject.first;
          if (existingTransaction.action == AppActions.synchronized) return;
          existingTransaction.updateProperties(realmVariant);
        }
      });
    }
    if (item is Stock) {
      if (item.action == AppActions.synchronized) return;
      realm!.write(() {
        final realmStock = RealmStock(
          item.id!,
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
          ebmSynced: item.ebmSynced,
          deletedAt: item.deletedAt,
        );
        final findableObject = realm!.query<RealmStock>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Stock doesn't exist, add it
          realm!.add(realmStock);
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
      realm!.write(() {
        IUnit data = item;
        final realmUnit = RealmIUnit(
          ObjectId(),
          data.id!, // Auto-generate ObjectId for realmId
          data.branchId,
          data.name,
          data.value,
          data.active,
        );

        final findableObject = realm!.query<RealmIUnit>(r'id == $0', [data.id]);

        if (findableObject.isEmpty) {
          // Unit doesn't exist, add it
          realm!.add(realmUnit);
        } else {
          // Unit exists, update it
          RealmIUnit existingUnit = findableObject.first;

          existingUnit.updateProperties(realmUnit);
        }
      });
    }
    if (item is Receipt) {
      realm!.write(() {
        final realmReceipt = RealmReceipt(
          ObjectId(),
          item.branchId,
          id: item.id,
          resultCd: item.resultCd,
          resultMsg: item.resultMsg,
          resultDt: item.resultDt,
          rcptNo: item.rcptNo,
          intrlData: item.intrlData,
          rcptSign: item.rcptSign,
          totRcptNo: item.totRcptNo,
          vsdcRcptPbctDate: item.vsdcRcptPbctDate,
          sdcId: item.sdcId,
          mrcNo: item.mrcNo,
          qrCode: item.qrCode,
          receiptType: item.receiptType,
          transactionId: item.transactionId,
        );
        final findableObject = realm!
            .query<RealmReceipt>(r'transactionId == $0', [item.transactionId]);

        if (findableObject.isEmpty) {
          // Unit doesn't exist, add it
          realm!.add(realmReceipt);
        } else {
          // Unit exists, update it
          RealmReceipt existingRealm = findableObject.first;

          existingRealm.updateProperties(realmReceipt);
        }
      });
    }
    if (item is Counter) {
      realm!.write(() {
        final realmCounter = RealmCounter(ObjectId(),
            id: item.id,
            branchId: item.branchId,
            businessId: item.businessId,
            receiptType: item.receiptType,
            totRcptNo: item.totRcptNo,
            curRcptNo: item.curRcptNo,
            lastTouched: item.lastTouched);
        final findableObject =
            realm!.query<RealmCounter>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Unit doesn't exist, add it
          realm!.add(realmCounter);
        } else {
          // Unit exists, update it
          RealmCounter existingRealm = findableObject.first;
          existingRealm.updateProperties(realmCounter);
        }
      });
    }
    if (item is Customer) {
      realm!.write(() {
        final realmCustomer = RealmCustomer(
          item.id!,
          ObjectId(),
          branchId: item.branchId,
          custNm: item.custNm,
          email: item.email,
          telNo: item.telNo,
          adrs: item.adrs,
          updatedAt: item.updatedAt,
          custNo: item.custNo,
          custTin: item.custTin,
          regrNm: item.regrNm,
          regrId: item.regrId,
          modrNm: item.modrNm,
          modrId: item.modrId,
          ebmSynced: item.ebmSynced,
          lastTouched: item.lastTouched,
          action: item.action,
          deletedAt: item.deletedAt,
          tin: item.tin,
          useYn: item.useYn,
        );
        final findableObject =
            realm!.query<RealmCustomer>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Unit doesn't exist, add it
          realm!.add(realmCustomer);
        } else {
          // Unit exists, update it
          RealmCustomer existingRealm = findableObject.first;
          existingRealm.updateProperties(realmCustomer);
        }
      });
    }
  }

  List<Isolate> _isolates = [];

  @override
  Future<void> pull() async {
    if (realm == null) return;

    ///first kill any nrunning isolate before creating new one
    for (Isolate isolate in _isolates) {
      isolate.kill(priority: Isolate.immediate);
    }

    await _spawnIsolate("transactions", IsolateHandler.handleTransactions);

    await _spawnIsolate(
        "transactionItems", IsolateHandler.handleTransactionItems);

    await _spawnIsolate("products", IsolateHandler.handleProducts);

    await _spawnIsolate("variants", IsolateHandler.handleVariants);

    await _spawnIsolate("stocks", IsolateHandler.handleStocs);
    await _spawnIsolate("counters", IsolateHandler.handleCounters);
  }

  Future<void> _spawnIsolate(String name, dynamic isolateHandler) async {
    try {
      String dbPath = await absolutePath("db_");
      String encryptionKey = ProxyService.box.encryptionKey();

      ReceivePort receivePort = ReceivePort();
      final isolate = await Isolate.spawn(
        isolateHandler,
        [
          RootIsolateToken.instance,
          receivePort.sendPort,
          ProxyService.box.getBranchId()!,
          dbPath,
          encryptionKey,
        ],
      );
      _isolates.add(isolate);
      receivePort.listen(
        (message) => {
          // log('Isolate $name: $message');
        },
      );
    } catch (error) {
      log('Error managing isolates: $error');
    }
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
    if (realm == null) return;
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
              await ProxyService.isar.getTransactionById(id: transaction.id!);
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
    if (realm == null) return null;
    realm!.close();
  }

  Future<bool> logout() async {
    ///https://stackoverflow.com/questions/40587563/when-should-i-call-realm-close
    ///until we have valid reason to close realm and logout
    ///then we are commenting code bellow
    ///this is because we are not interested in realm data once user logs out
    ///because technicaly it is not a problem to have realm data after logout on google auth main auth
    ///
    // final app = App(AppConfiguration(AppSecrets.appId,
    //     baseUrl: Uri.parse("https://services.cloud.mongodb.com")));
    // final user = app.currentUser ??
    //     await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));
    // await user.logOut();
    //    realm!.close();
    return true;
  }

  @override
  Future<void> syncCounter() async {
    if (realm == null) return;
    log('calling heart beat');
    int branchId = ProxyService.box.getBranchId()!;
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AppSecrets.mongoEndPoint));
    request.body = json.encode({
      "collection": "RealmCounter",
      "database": "flipper",
      "dataSource": "Cluster0",
      "filter": {"branchId": branchId},
      "sort": {"createdAt": -1}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(jsonString);
      log(jsonResponse.toString());

      if (jsonResponse.containsKey("documents")) {
        List<Map<String, dynamic>> jsonList =
            List.from(jsonResponse["documents"]);

        List<Counter> counters =
            jsonList.map((jsonMap) => Counter.fromJson(jsonMap)).toList();
        // loop through counters and then update all of them
        for (Counter counter in counters) {
          await ProxyService.isar.update(data: counter);
          log("done updating ${counter.receiptType}");
        }
      } else {
        log("Noop");
      }
    } else {
      log(response.statusCode.toString());
    }
  }

  @override
  Future<Branch?> activeBranch() async {
    // get active branch from realm db
    final branch = realm!.query<RealmBranch>(r'active == $0', [true]).first;
    // branch.id;
    return Branch.fromJson(branch.toEJson() as Map<String, dynamic>);
  }

  @override
  Future<Category?> activeCategory({required int branchId}) {
    // TODO: implement activeCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Social>> activesocialAccounts({required int branchId}) {
    // TODO: implement activesocialAccounts
    throw UnimplementedError();
  }

  @override
  Future<List<UserActivity>> activities({required int userId}) {
    // TODO: implement activities
    throw UnimplementedError();
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId}) {
    // TODO: implement addCustomer
    throw UnimplementedError();
  }

  @override
  Future<int> addFavorite({required Favorite data}) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Future<Pointss> addPoint({required int userId, required int point}) {
    // TODO: implement addPoint
    throw UnimplementedError();
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError();
  }

  @override
  Future<void> addTransactionItem(
      {required ITransaction transaction, required TransactionItem item}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError();
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<int> addVariant({required List<Variant> variations}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future assignCustomerToTransaction(
      {required int customerId, int? transactionId}) {
    // TODO: implement assignCustomerToTransaction
    throw UnimplementedError();
  }

  @override
  Stream<ITenant?> authState({required int branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct({required int productId, required int tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({int? businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<BusinessType>> businessTypes() {
    // TODO: implement businessTypes
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> businesses({int? userId}) {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required int branchId}) {
    // TODO: implement categories
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIn({required String? checkInCode}) {
    // TODO: implement checkIn
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  Future<void> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType}) {
    // TODO: implement collectPayment
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) {
    // TODO: implement completedTransactions
    throw UnimplementedError();
  }

  @override
  void consumePoints({required int userId, required int points}) {
    // TODO: implement consumePoints
  }

  @override
  Future<Voucher?> consumeVoucher({required int voucherCode}) {
    // TODO: implement consumeVoucher
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> conversations({String? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  T? create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) {
    // TODO: implement createGoogleSheetDoc
    throw UnimplementedError();
  }

  @override
  Future<Pin?> createPin() {
    // TODO: implement createPin
    throw UnimplementedError();
  }

  @override
  Future<Product?> createProduct(
      {required Product product, bool skipRegularVariant = false}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> createReceipt(
      {required EBMApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter}) {
    // TODO: implement createReceipt
    throw UnimplementedError();
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) {
    // TODO: implement createSetting
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> customers({required int branchId}) {
    // TODO: implement customers
    throw UnimplementedError();
  }

  @override
  String dbPath() {
    // TODO: implement dbPath
    throw UnimplementedError();
  }

  @override
  Future<Branch?> defaultBranch() {
    // TODO: implement defaultBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> defaultBusiness() {
    // TODO: implement defaultBusiness
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required int id, String? endPoint}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllProducts() {
    // TODO: implement deleteAllProducts
    throw UnimplementedError();
  }

  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) {
    // TODO: implement deleteFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) {
    // TODO: implement deleteTransactionByIndex
    throw UnimplementedError();
  }

  @override
  void emptySentMessageQueue() {
    // TODO: implement emptySentMessageQueue
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) {
    // TODO: implement enableAttendance
    throw UnimplementedError();
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) {
    // TODO: implement findProductByTenantId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
    // TODO: implement geVariantStreamByProductId
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusiness({int? businessId}) {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required int id}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) {
    // TODO: implement getConversation
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) {
    // TODO: implement getCounter
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomVariant() {
    // TODO: implement getCustomVariant
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getCustomer({String? key, int? id}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Stream<ITenant?> getDefaultTenant({required int businessId}) {
    // TODO: implement getDefaultTenant
    throw UnimplementedError();
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) {
    // TODO: implement getDevice
    throw UnimplementedError();
  }

  @override
  Future<Device?> getDeviceById({required int id}) {
    // TODO: implement getDeviceById
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) {
    // TODO: implement getDiscounts
    throw UnimplementedError();
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) {
    // TODO: implement getDrawer
    throw UnimplementedError();
  }

  @override
  Future<EBM?> getEbmByBranchId({required int branchId}) {
    // TODO: implement getEbmByBranchId
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) {
    // TODO: implement getFavoriteById
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) {
    // TODO: implement getFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    // TODO: implement getFavoriteByIndexStream
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) {
    // TODO: implement getFavoriteByProdId
    throw UnimplementedError();
  }

  @override
  Future<List<Favorite>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<Business> getOnlineBusiness({required int userId}) {
    // TODO: implement getOnlineBusiness
    throw UnimplementedError();
  }

  @override
  Future<Pin?> getPin({required String pin}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Future<Pointss?> getPoints({required int userId}) {
    // TODO: implement getPoints
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProduct({required int id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Future<List<Product?>> getProductByName({required String name}) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductList({int? prodIndex}) {
    // TODO: implement getProductList
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) {
    // TODO: implement getReceipt
    throw UnimplementedError();
  }

  @override
  Future<List<Conversation>> getScheduleMessages() {
    // TODO: implement getScheduleMessages
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<Social?> getSocialById({required int id}) {
    // TODO: implement getSocialById
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSocialSetting() {
    // TODO: implement getSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock({required int branchId, required int variantId}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStockById({required int id}) {
    // TODO: implement getStockById
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockStream({int? productId, int? variantId}) {
    // TODO: implement getStockStream
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockValue({required int branchId}) {
    // TODO: implement getStockValue
    throw UnimplementedError();
  }

  @override
  Future<ITenant?> getTenantBYPin({required int pin}) {
    // TODO: implement getTenantBYPin
    throw UnimplementedError();
  }

  @override
  Future<ITenant?> getTenantBYUserId({required int userId}) {
    // TODO: implement getTenantBYUserId
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> getTransactionById({required int id}) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) {
    // TODO: implement getTransactionItemsByTransactionId
    throw UnimplementedError();
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) {
    // TODO: implement getTransactionsAmountsSum
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required int customerId}) {
    // TODO: implement getTransactionsByCustomerId
    throw UnimplementedError();
  }

  @override
  Future<
      ({
        List<Device> devices,
        List<Favorite> favorites,
        List<Product> products,
        List<Stock> stocks,
        List<TransactionItem> transactionItems,
        List<ITransaction> transactions,
        List<Variant> variants
      })> getUnSyncedData() {
    // TODO: implement getUnSyncedData
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getVariantById({required int id}) {
    // TODO: implement getVariantById
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> getVariantByProductId({int? productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    // TODO: implement getVariantByProductIdStream
    throw UnimplementedError();
  }

  @override
  Future<bool> isDrawerOpen({required int cashierId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled() {
    // TODO: implement isTaxEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId}) {
    // TODO: implement isTokenValid
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  Future<void> loadCounterFromOnline({required int businessId}) {
    // TODO: implement loadCounterFromOnline
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> logOutLight() {
    // TODO: implement logOutLight
    throw UnimplementedError();
  }

  @override
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType}) {
    // TODO: implement manageCashInOutTransaction
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageTransaction({required String transactionType}) {
    // TODO: implement manageTransaction
    throw UnimplementedError();
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType}) {
    // TODO: implement pendingTransaction
    throw UnimplementedError();
  }

  @override
  Future<Permission?> permission({required int userId}) {
    // TODO: implement permission
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    // TODO: implement productStreams
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }

  @override
  Future<Profile?> profile({required int businessId}) {
    // TODO: implement profile
    throw UnimplementedError();
  }

  @override
  Future<void> recordUserActivity(
      {required int userId, required String activity}) {
    // TODO: implement recordUserActivity
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password}) {
    // TODO: implement registerOnSocial
    throw UnimplementedError();
  }

  @override
  Future removeCustomerFromTransaction(
      {required int customerId, required int transactionId}) {
    // TODO: implement removeCustomerFromTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required String userType}) {
    // TODO: implement saveTenant
    throw UnimplementedError();
  }

  @override
  Future<Conversation> sendMessage(
      {required String message, required Conversation latestConversation}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<void> sendScheduleMessages() {
    // TODO: implement sendScheduleMessages
    throw UnimplementedError();
  }

  @override
  Future<List<Tenant>> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stream<Social> socialsStream({required int branchId}) {
    // TODO: implement socialsStream
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment({required double amount, required phoneNumber}) {
    // TODO: implement spennPayment
    throw UnimplementedError();
  }

  @override
  Future<Stock?> stockByVariantId(
      {required int variantId, bool nonZeroValue = false}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Future<double> stocks({int? productId, int? variantId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  bool subscribe(
      {required String feature,
      required int businessId,
      required int agentCode}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  bool suggestRestore() {
    // TODO: implement suggestRestore
    throw UnimplementedError();
  }

  @override
  Future<void> syncProduct(
      {required Product product,
      required Variant variant,
      required Stock stock}) {
    // TODO: implement syncProduct
    throw UnimplementedError();
  }

  @override
  Future<List<SyncRecord>> syncedModels({required int branchId}) {
    // TODO: implement syncedModels
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> tenants({int? businessId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) {
    // TODO: implement tenantsFromOnline
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> ticketsStreams() {
    // TODO: implement ticketsStreams
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionItem>> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItems
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement transactionList
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> transactionsFuture(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    // TODO: implement transactionsFuture
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    // TODO: implement transactionsStream
    throw UnimplementedError();
  }

  @override
  Future<List<IUnit>> units({required int branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required T data, bool localUpdate = false}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }

  @override
  Future<Profile?> updateProfile({required Profile profile}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable({required String name}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<Variant?> variant({int? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> variants({required int branchId, int? productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }
}
