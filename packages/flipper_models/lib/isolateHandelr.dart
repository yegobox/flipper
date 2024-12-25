import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/firebase_options.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/helperModels/UniversalProduct.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:supabase_models/brick/repository.dart';
import 'package:sqlite3/sqlite3.dart';

final repository = Repository();
mixin VariantPatch {
  static Future<void> patchVariant(
      {required String URI, required Function(String) sendPort}) async {
    final variants = await repository.get<Variant>(
        query: brick.Query(where: [Where('ebmSynced').isExactly(false)]));

    for (Variant variant in variants) {
      try {
        IVariant iVariant = IVariant.fromJson(variant.toJson());

        final response = await RWTax().saveItem(variation: iVariant, URI: URI);

        if (response.resultCd == "000") {
          sendPort('${response.resultMsg}:variant:${variant.id.toString()}');

          variant.ebmSynced = true;
          repository.upsert(variant);
        }
      } catch (e, s) {
        talker.error(e, s);
        rethrow;
      }
    }
  }
}
mixin StockPatch {
  static Future<void> patchStock(
      {required String URI, required Function(String) sendPort}) async {
    final stocks = await repository.get<Stock>(
        query: brick.Query(where: [Where('ebmSynced').isExactly(false)]));

    Map<int, Variant?> variantMap = {};

    for (Stock stock in stocks) {
      if (!stock.ebmSynced!) {
        Variant? variant = variantMap[stock.variantId];
        if (variant == null) {
          continue;
        }

        try {
          IStock iStock = IStock(
            id: stock.id,
            currentStock: stock.currentStock!,
          );
          IVariant iVariant = IVariant.fromJson(variant.toJson());

          final response = await RWTax()
              .saveStockMaster(stock: iStock, variant: iVariant, URI: URI);
          if (response.resultCd == "000") {
            sendPort('${response.resultMsg}');
            stock.ebmSynced = true;
            repository.upsert(stock);
          } else {
            sendPort('${response.resultMsg}}');
          }
        } catch (e) {
          rethrow;
        }
      }
    }
  }
}
mixin PatchTransactionItem {
  static Future<void> patchTransactionItem(
      {required String URI,
      required Function(String) sendPort,
      required int tinNumber,
      required String bhfId}) async {
    final transactions = await repository.get<ITransaction>(
        query: brick.Query(where: [
      Where('ebmSynced').isExactly(false),
      Where('status').isExactly(COMPLETE),
      Where('customerName').isNot(null),
      Where('customerTin').isNot(null)
    ]));
    for (ITransaction transaction in transactions) {
      double taxB = 0;

      double totalvat = 0;
      Configurations taxConfigTaxB = (await repository.get<Configurations>(
              query: brick.Query(where: [Where('taxType').isExactly("B")])))
          .first;

      List<TransactionItem> items = await repository.get<TransactionItem>(
          query: brick.Query(
              where: [Where('transactionId').isExactly(transaction.id)]));

      for (var item in items) {
        if (item.taxTyCd == "B") {
          taxB += (item.price * item.qty);
        }
      }

      final totalTaxB = calculateTotalTax(taxB, taxConfigTaxB);

      totalvat = totalTaxB;

      if (transaction.customerName == null || transaction.customerTin == null) {
        continue;
      }
      try {
        final response = await RWTax().saveStockItems(
            transaction: transaction,
            tinNumber: tinNumber.toString(),
            bhFId: bhfId,
            customerName: transaction.customerName ?? "N/A",
            custTin: transaction.customerTin ?? "999909695",
            regTyCd: "A",
            sarTyCd: transaction.sarTyCd ?? "11",
            custBhfId: transaction.customerBhfId ?? "",
            totalSupplyPrice: transaction.subTotal!,
            totalvat: totalvat,
            totalAmount: transaction.subTotal!,
            remark: transaction.remark ?? "",
            ocrnDt: DateTime.parse(
                transaction.updatedAt ?? DateTime.now().toString()),
            URI: URI);

        if (response.resultCd == "000") {
          sendPort(
              'notification:${response.resultMsg}:transaction:${transaction.id.toString()}');

          transaction.ebmSynced = true;
          repository.upsert(transaction);
        } else {
          sendPort('notification:${response.resultMsg}}');
        }
        print(response);
      } catch (e) {}
    }
  }

  static double calculateTotalTax(double tax, Configurations config) {
    final percentage = config.taxPercentage ?? 0;
    return (tax * percentage) / 100 + percentage;
  }
}
mixin CustomerPatch {
  static void patchCustomer(
      {required String URI,
      required Function(String) sendPort,
      required int tinNumber,
      required String bhfId,
      required int branchId}) async {
    final customers = await repository.get<Customer>(
        query: brick.Query(where: [Where('branchId').isExactly(branchId)]));

    for (Customer customer in customers) {
      if (!customer.ebmSynced!) {
        try {
          customer.tin = tinNumber;
          customer.bhfId = bhfId;
          repository.upsert(customer);

          if ((customer.custTin?.length ?? 0) < 9) return;
          ICustomer iCustomer = ICustomer.fromJson(customer.toJson());

          final response =
              await RWTax().saveCustomer(customer: iCustomer, URI: URI);
          if (response.resultCd == "000") {
            sendPort(
                'notification:${response.resultMsg.substring(0, 10)}:customer:${customer.id.toString()}');
          } else {
            sendPort('notification:${response.resultMsg}}');
          }
        } catch (e) {}
      }
    }
  }
}

class IsolateHandler with StockPatch {
  static Future<void> clearFirestoreCache() async {
    try {
      await FirebaseFirestore.instance.clearPersistence();
    } catch (e) {}
  }

  static Future<void> handler(List<dynamic> args) async {
    final SendPort sendPort = args[0];
    final RootIsolateToken rootIsolateToken = args[1];
    DartPluginRegistrant.ensureInitialized();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    ReceivePort port = ReceivePort();

    sendPort.send(port.sendPort);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    port.listen((message) async {
      if (message is Map<String, dynamic>) {
        if (message['task'] == 'taxService') {
          int branchId = message['branchId'];

          int businessId = message['businessId'];
          String dbPath = message['dbPath'];

          String URI = message['URI'];
          String bhfId = message['bhfId'];

          localData(args,
              dbPath: dbPath,
              branchId: branchId,
              businessId: businessId,
              bhfid: bhfId,
              URI: URI);
        }
      }
    });
  }

  static Future<void> localData(List<dynamic> args,
      {required int branchId,
      required int businessId,
      required String dbPath,
      required String bhfid,
      required String URI}) async {
    final rootIsolateToken = args[1] as RootIsolateToken;

    await fetchDataAndSaveUniversalProducts(businessId, branchId, URI, bhfid,
        dbPath: dbPath);
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    DartPluginRegistrant.ensureInitialized();
  }

  static Future<void> fetchDataAndSaveUniversalProducts(
    int businessId,
    int branchId,
    String URI,
    String bhfid, {
    required String dbPath,
  }) async {
    try {
      final db = sqlite3.open(dbPath);
      final result =
          db.select("Select * from Business where server_id = $businessId");

      print(result.single.toString());
      Business business = Business.fromMap(result.single);
      final url = URI + "/itemClass/selectItemsClass";
      print(url);
      print(bhfid);
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "tin": business.tinNumber,
        "bhfId": bhfid,
        "lastReqDt": "20210523000000",
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null &&
            jsonResponse['data']['itemClsList'] != null) {
          final List<dynamic> itemClsList = jsonResponse['data']['itemClsList'];

          for (var item in itemClsList) {
            final UniversalProduct product = UniversalProduct.fromJson(item);
            final result = db.select(
                "SELECT * FROM UnversalProduct WHERE item_cls_cd = ?",
                [product.itemClsCd]);

            if (result.isEmpty) {
              final unii = UnversalProduct(
                id: randomNumber(),
                itemClsCd: product.itemClsCd,
                itemClsLvl: product.itemClsLvl,
                itemClsNm: product.itemClsNm,
                branchId: branchId,
                businessId: businessId,
                useYn: product.useYn,
                mjrTgYn: product.mjrTgYn,
                taxTyCd: product.taxTyCd,
              );

              db.execute(
                  "INSERT INTO UnversalProduct (id, item_cls_cd, item_cls_lvl, item_cls_nm, branch_id, business_id, use_yn, mjr_tg_yn, tax_ty_cd) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                  [
                    unii.id,
                    unii.itemClsCd,
                    unii.itemClsLvl,
                    unii.itemClsNm,
                    unii.branchId,
                    unii.businessId,
                    unii.useYn,
                    unii.mjrTgYn,
                    unii.taxTyCd
                  ]);
            }
          }
        } else {
          print('No data found in the response.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
