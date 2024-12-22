import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/firebase_options.dart';
import 'package:flipper_models/realm_model_export.dart';

import 'package:flutter/services.dart';
import 'dart:async';

class IsolateHandler {
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

    // port.listen((message) async {
    //   if (message is Map<String, dynamic>) {
    //     print("Message received");
    //     String local = message['dbPath'];
    //     String encryptionKey = message['encryptionKey'];
    //     LocalConfiguration configLocal =
    //         localConfig(encryptionKey.toIntList(), local);
    //     if (localRealm == null) {
    //       localRealm = Realm(configLocal);
    //     }

    //     if (message['task'] == 'sync') {}
    //     if (message['task'] == 'taxService') {
    //       int branchId = message['branchId'];
    //       int tinNumber = message['tinNumber'];

    //       String URI = message['URI'];
    //       String bhfId = message['bhfId'];
    //       String encryptionKey = message['encryptionKey'];
    //       String local = message['dbPath'];

    //       LocalConfiguration configLocal =
    //           localConfig(encryptionKey.toIntList(), local);

    //       if (localRealm == null) {
    //         localRealm = Realm(configLocal);
    //       }
    //       double calculateTotalTax(double tax, Configurations config) {
    //         final percentage = config.taxPercentage ?? 0;
    //         return (tax * percentage) / 100 + percentage;
    //       }

    //       _selfHeal(localRealm: localRealm);

    //       List<ITransaction> transactions = localRealm!.query<ITransaction>(
    //           r'ebmSynced == $0 && status == $1 && customerName != null && customerTin != null',
    //           [false, COMPLETE]).toList();

    //       print("transactions count ${transactions.length}");
    //       for (ITransaction transaction in transactions) {
    //         double taxB = 0;

    //         double totalvat = 0;

    //         Configurations taxConfigTaxB = localRealm!
    //             .query<Configurations>(r'taxType == $0', ["B"]).first;

    //         List<TransactionItem> items = localRealm!.query<TransactionItem>(
    //             r'transactionId == $0', [transaction.id]).toList();

    //         for (var item in items) {
    //           if (item.taxTyCd == "B") {
    //             taxB += (item.price * item.qty);
    //           }
    //         }

    //         final totalTaxB = calculateTotalTax(taxB, taxConfigTaxB);

    //         totalvat = totalTaxB;

    //         if (transaction.customerName == null ||
    //             transaction.customerTin == null) {
    //           continue;
    //         }
    //         try {
    //           final response = await RWTax().saveStockItems(
    //               transaction: transaction,
    //               tinNumber: tinNumber.toString(),
    //               bhFId: bhfId,
    //               customerName: transaction.customerName ?? "N/A",
    //               custTin: transaction.customerTin ?? "999909695",
    //               regTyCd: "A",
    //               sarTyCd: transaction.sarTyCd ?? "11",
    //               realm: localRealm!,
    //               custBhfId: transaction.customerBhfId ?? "",
    //               totalSupplyPrice: transaction.subTotal,
    //               totalvat: totalvat,
    //               totalAmount: transaction.subTotal,
    //               remark: transaction.remark ?? "",
    //               ocrnDt: DateTime.parse(
    //                   transaction.updatedAt ?? DateTime.now().toString()),
    //               URI: URI);

    //           if (response.resultCd == "000") {
    //             sendPort.send(
    //                 'notification:${response.resultMsg}:transaction:${transaction.id.toString()}');
    //           } else {
    //             sendPort.send('notification:${response.resultMsg}}');
    //           }
    //           print(response);
    //         } catch (e) {}
    //       }

    //       List<Stock> stocks =
    //           localRealm!.query<Stock>(r'ebmSynced ==$0', [false]).toList();

    //       List<int?> variantIds =
    //           stocks.map((stock) => stock.variantId).toList();
    //       Map<int, Variant?> variantMap = {};
    //       localRealm!
    //           .query<Variant>(r'id IN $0', [variantIds]).forEach((variant) {
    //         variantMap[variant.id!] = variant;
    //       });
    //       for (Stock stock in stocks) {
    //         if (!stock.ebmSynced) {
    //           Variant? variant = variantMap[stock.variantId];
    //           if (variant == null) {
    //             continue;
    //           }

    //           try {
    //             IStock iStock = IStock(
    //               id: stock.id,
    //               currentStock: stock.currentStock,
    //             );
    //             IVariant iVariant =
    //                 IVariant.fromJson(variant.toFlipperJson());

    //             final response = await RWTax().saveStockMaster(
    //                 stock: iStock, variant: iVariant, URI: URI);
    //             if (response.resultCd == "000") {
    //               sendPort.send(
    //                   'notification:${response.resultMsg}:stock:${stock.id.toString()}');
    //             } else {
    //               sendPort.send('notification:${response.resultMsg}}');
    //             }
    //           } catch (e) {
    //             rethrow;
    //           }
    //         }
    //       }

    //       List<Variant> variants =
    //           localRealm!.query<Variant>(r'ebmSynced == $0', [false]).toList();

    //       for (Variant variant in variants) {
    //         try {
    //           IVariant iVariant =
    //               IVariant.fromJson(variant.toFlipperJson());

    //           iVariant.isrcAplcbYn = variant.isrcAplcbYn?.isEmpty ?? true
    //               ? "N"
    //               : variant.isrcAplcbYn;

    //           if (variant.qtyUnitCd == null ||
    //               variant.taxTyCd == null ||
    //               variant.bhfId == null ||
    //               variant.bhfId!.isEmpty) return;
    //           final response =
    //               await RWTax().saveItem(variation: iVariant, URI: URI);

    //           if (response.resultCd == "000") {
    //             sendPort.send(
    //                 'notification:${response.resultMsg}:variant:${variant.id.toString()}');
    //           } else {
    //             sendPort.send('notification:${response.resultMsg}}');
    //           }
    //         } catch (e, s) {
    //           talker.error(s);
    //         }
    //       }

    //       List<Customer> customers = localRealm!
    //           .query<Customer>(r'branchId ==$0', [branchId]).toList();

    //       for (Customer customer in customers) {
    //         if (!customer.ebmSynced) {
    //           try {
    //             localRealm!.write(() {
    //               customer.tin = tinNumber;
    //               customer.bhfId = bhfId;
    //             });

    //             if ((customer.custTin?.length ?? 0) < 9) return;
    //             ICustomer iCustomer =
    //                 ICustomer.fromJson(customer.toFlipperJson());

    //             final response =
    //                 await RWTax().saveCustomer(customer: iCustomer, URI: URI);
    //             if (response.resultCd == "000") {
    //               sendPort.send(
    //                   'notification:${response.resultMsg.substring(0, 10)}:customer:${customer.id.toString()}');
    //             } else {
    //               sendPort.send('notification:${response.resultMsg}}');
    //             }
    //           } catch (e) {}
    //         }
    //       }
    //     }
    //   }
    // });
  }

  // static LocalConfiguration localConfig(
  //   List<int> encryptionKey,
  //   String dbPatch,
  // ) {
  //   final config = Configuration.local(
  //     localModels,
  //     encryptionKey: encryptionKey,
  //     path: dbPatch,
  //     schemaVersion: schemaVersion,
  //     migrationCallback: (migration, oldSchemaVersion) {
  //       if (oldSchemaVersion < 2) {
  //         migration.deleteType('Drawers');
  //       }
  //       if (oldSchemaVersion < 7) {
  //         migration.deleteType('Log');
  //       }
  //     },
  //   );
  // return config;
  // }

  static Future<void> localData(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;

    final dbPatch = args[3] as String;
    String? key = args[4] as String?;

    int? branchId = args[2] as int?;
    int? businessId = args[7] as int?;
    String? bhfid = args[6] as String?;
    String? URI = args[8] as String?;
    if (key == null ||
        branchId == null ||
        businessId == null ||
        bhfid == null ||
        URI == null) return;

    List<int> encryptionKey = key.toIntList();
    // LocalConfiguration config = localConfig(encryptionKey, dbPatch);
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    DartPluginRegistrant.ensureInitialized();

    // localRealm = Realm(config);
  }

  static Future<void> fetchDataAndSaveUniversalProducts(
      int businessId, int branchId, String URI, String bhfid) async {
    // try {
    //   Business business =
    //       localRealm!.query<Business>(r'serverId == $0', [businessId]).first;

    //   final url = URI + "/itemClass/selectItemsClass";
    //   final headers = {"Content-Type": "application/json"};
    //   final body = jsonEncode({
    //     "tin": business.tinNumber,
    //     "bhfId": bhfid,
    //     "lastReqDt": "20190523000000",
    //   });
    //   print("Loading item codes");
    //   final response =
    //       await http.post(Uri.parse(url), headers: headers, body: body);
    //   if (response.statusCode == 200) {
    //     final jsonResponse = json.decode(response.body);

    //     if (jsonResponse['data'] != null &&
    //         jsonResponse['data']['itemClsList'] != null) {
    //       final List<dynamic> itemClsList = jsonResponse['data']['itemClsList'];

    //       for (var item in itemClsList) {
    //         final UniversalProduct product = UniversalProduct.fromJson(item);
    //         UnversalProduct? uni = localRealm!.query<UnversalProduct>(
    //             r'itemClsCd == $0', [product.itemClsCd]).firstOrNull;
    //         if (uni == null) {
    //           localRealm!.write(() {
    //             localRealm!.add(
    //               UnversalProduct(
    //                 id: randomNumber(),
    //                 itemClsCd: product.itemClsCd,
    //                 itemClsLvl: product.itemClsLvl,
    //                 itemClsNm: product.itemClsNm,
    //                 branchId: branchId,
    //                 businessId: businessId,
    //                 useYn: product.useYn,
    //                 mjrTgYn: product.mjrTgYn,
    //                 taxTyCd: product.taxTyCd,
    //               ),
    //             );
    //           });
    //         }
    //       }
    //     } else {
    //       print('No data found in the response.');
    //     }
    //   } else {
    //     print('Failed to load data. Status code: ${response.statusCode}');
    //   }
    // } catch (e) {}
  }

  static void _selfHeal() {
    // List<Stock> stocks = localRealm!.query<Stock>(r'variant == NULL').toList();

    // for (Stock stock in stocks) {
    //   Variant? variant =
    //       localRealm.query<Variant>(r'id == $0', [stock.variantId]).firstOrNull;

    //   localRealm.write(() {
    //     if (variant != null) {
    //       print("Healed Stock: ${stock.id}");
    //     }
    //   });
    // }

    // List<Variant> vVariants =
    //     localRealm.query<Variant>(r'productName == NULL').toList();
    // for (Variant variant in vVariants) {
    //   Product? product = localRealm
    //       .query<Product>(r'id == $0', [variant.productId]).firstOrNull;
    //   if (product != null) {
    //     localRealm.write(() {
    //       print("healedProductName: ${variant.id}");
    //       variant.productName = product.name;
    //     });
    //   }
    // }

    // List<Variant> variants = localRealm
    //     .query<Variant>(r'itemClsCd == null OR itemClsCd == ""')
    //     .toList();

    // for (Variant variant in variants) {
    //   localRealm.write(() {
    //     variant.itemClsCd = "5020230602";
    //   });
    // }

    // List<TransactionItem> items = localRealm
    //     .query<TransactionItem>(r'itemClsCd == null OR itemClsCd == ""')
    //     .toList();
    // for (TransactionItem item in items) {
    //   localRealm.write(() {
    //     item.itemClsCd = "5020230602";
    //   });
    // }

    // List<Variant> variantsall = localRealm.all<Variant>().toList();

    // for (Variant variant in variantsall) {
    //   final stock =
    //       localRealm.query<Stock>(r'variantId == $0', [variant.id]).firstOrNull;
    //   if (stock == null) {
    //     print("healed Stock: ${variant.id}");
    //     localRealm.write(() {
    //       final newStock = Stock(
    //         id: randomNumber(),
    //         lastTouched: DateTime.now(),
    //         branchId: variant.branchId,
    //         variantId: variant.id!,
    //         currentStock: variant.stock?.rsdQty ?? 0,
    //         rsdQty: variant.stock?.rsdQty ?? 0,
    //         ebmSynced: false,
    //         value:
    //             (variant.stock?.rsdQty ?? 0 * variant.retailPrice).toDouble(),
    //         productId: variant.productId,
    //         active: false,
    //       );
    //       localRealm.add(newStock);
    //     });
    //   }
    // }

    // List<Configurations> configurations =
    //     localRealm.all<Configurations>().toList();
    // Set<String> uniqueTaxTypes = {};

    // for (Configurations config in configurations) {
    //   if (!uniqueTaxTypes.contains(config.taxType!)) {
    //     uniqueTaxTypes.add(config.taxType!);
    //   } else {
    //     localRealm.write(() {
    //       localRealm.delete(config);
    //       print("Deleted unnessary taxes");
    //     });
    //   }
    // }

    // List<EBM> ebms = localRealm.all<EBM>().toList();
    // Set<String> uniqueEbms = {};

    // for (EBM config in ebms) {
    //   if (!uniqueEbms.contains(config.branchId.toString())) {
    //     uniqueEbms.add(config.branchId.toString());
    //   } else {
    //     localRealm.write(() {
    //       localRealm.delete(config);
    //       print("Deleted ebm config");
    //     });
    //   }
    // }
    // List<Variant> variantsAll = localRealm.all<Variant>().toList();
    // List<ITransaction> transactions = localRealm.all<ITransaction>().toList();
    // for (ITransaction transaction in transactions) {
    //   final TransactionPaymentRecord? record = localRealm
    //       .query<TransactionPaymentRecord>(
    //           r'transactionId == $0', [transaction.id]).firstOrNull;
    //   if (record == null) {
    //     localRealm.write(() {
    //       localRealm.add<TransactionPaymentRecord>(TransactionPaymentRecord(
    //         amount: transaction.cashReceived,
    //         transactionId: transaction.id!,
    //         paymentMethod: transaction.paymentType,
    //       ));
    //     });
    //   }
    // }

    // List<Stock> stockss =
    //     localRealm.query<Stock>(r'initialStock == NULL').toList();

    // for (Stock stock in stockss) {
    //   if (stock.initialStock == null) {
    //     localRealm.write(() {
    //       stock.initialStock = stock.currentStock;
    //     });
    //   }
    // }

    // for (Variant variant in variantsAll) {
    //   if (variant.stock == null) {
    //     Stock? stock = localRealm.query<Stock>(
    //         r'variantId ==$0 && branchId == $1',
    //         [variant.id, variant.branchId]).firstOrNull;
    //     if (stock != null) {
    //       localRealm.write(() {
    //         variant.stock = stock;
    //         print("Updated stock");
    //       });
    //     } else {
    //       localRealm.write(() {
    //         final id = randomNumber();
    //         localRealm.add(
    //           Stock(
    //             id: id,
    //             lastTouched: DateTime.now(),
    //             branchId: variant.branchId,
    //             variantId: variant.id!,
    //             currentStock: variant.stock?.rsdQty ?? 0,
    //             rsdQty: variant.stock?.rsdQty ?? 0,
    //             value: (variant.stock?.rsdQty ?? 0 * (variant.retailPrice))
    //                 .toDouble(),
    //             productId: variant.productId,
    //             active: false,
    //           ),
    //         );

    //         final stock =
    //             localRealm.query<Stock>(r'id == $0', [id]).firstOrNull;
    //         variant.stock = stock;
    //       });
    //     }
    //   }
    // }
  }
}
