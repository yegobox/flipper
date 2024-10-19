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
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_services/PullChange.dart';
import 'package:flipper_services/constants.dart';

import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'dart:async';

class IsolateHandler {
  static Realm? localRealm;

  static Future<void> handler(List<dynamic> args) async {
    final SendPort sendPort = args[0];
    final RootIsolateToken rootIsolateToken = args[1];
    DartPluginRegistrant.ensureInitialized();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // Create a new ReceivePort for the isolate to receive messages
    ReceivePort port = ReceivePort();
    // Send this ReceivePort's SendPort back to the main isolate for communication
    /// for firestore it require to be re-initialized within isolate
    sendPort.send(port.sendPort);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final firestore = FirebaseFirestore.instance;

    port.listen((message) async {
      if (message is Map<String, dynamic>) {
        if (message['task'] == 'sync') {
          String encryptionKey = message['encryptionKey'];
          String local = message['dbPath'];
          int businessId = message['businessId'];
          int branchId = message['branchId'];
          int userId = message['userId'];
          LocalConfiguration configLocal =
              localConfig(encryptionKey.toIntList(), local);
          if (localRealm == null) {
            localRealm = Realm(configLocal);
          }

          /// query products from firestore
          // firestore.collection(stocksTable).get().then((value) {
          //   for (var doc in value.docs) {
          //     // final stock = doc.data();
          //     // print(stock);
          //     // final stock = Stock.fromJson(stock);
          //   }
          // });

          /// un comment this when https://github.com/flutter/flutter/issues/119207
          await PullChange().startAsync(
            mbusinessId: businessId,
            firestore: firestore,
            localRealm: localRealm!,
            mbranchId: branchId,
            muserId: userId,
          );
        }
        if (message['task'] == 'taxService') {
          int branchId = message['branchId'];
          int tinNumber = message['tinNumber'];

          String URI = message['URI'];
          String bhfId = message['bhfId'];
          String encryptionKey = message['encryptionKey'];
          String local = message['dbPath'];
          //  sendPort.send('notification:hello');
          // BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

          LocalConfiguration configLocal =
              localConfig(encryptionKey.toIntList(), local);

          if (localRealm == null) {
            localRealm = Realm(configLocal);
          }
          double calculateTotalTax(double tax, Configurations config) {
            final percentage = config.taxPercentage ?? 0;
            return (tax * percentage) / 100 + percentage;
          }

          /// handle missing value, part of self healing
          _selfHeal(localRealm: localRealm);

          List<ITransaction> transactions = localRealm!.query<ITransaction>(
              r'ebmSynced == $0 && status == $1 && customerName != null && customerTin != null',
              [false, COMPLETE]).toList();

          print("transactions count ${transactions.length}");
          for (ITransaction transaction in transactions) {
            double taxB = 0;
            // double taxC = 0;
            // double taxA = 0;
            // double taxD = 0;
            double totalvat = 0;

            Configurations taxConfigTaxB = localRealm!
                .query<Configurations>(r'taxType == $0', ["B"]).first;
            // Configurations taxConfigTaxA =
            //     localRealm!.query<Configurations>(r'taxType == $0', ["A"]).first;
            // Configurations taxConfigTaxC =
            //     localRealm!.query<Configurations>(r'taxType == $0', ["C"]).first;
            // Configurations taxConfigTaxD =
            //     localRealm!.query<Configurations>(r'taxType == $0', ["D"]).first;

            List<TransactionItem> items = localRealm!.query<TransactionItem>(
                r'transactionId == $0', [transaction.id]).toList();

            for (var item in items) {
              if (item.taxTyCd == "B") {
                taxB += (item.price * item.qty);
              }
              // if (item.taxTyCd == "C") {
              //   taxC += (item.price * item.qty);
              // }
              // if (item.taxTyCd == "A") {
              //   taxA += (item.price * item.qty);
              // }
              // if (item.taxTyCd == "D") {
              //   taxD += (item.price * item.qty);
              // }
            }
            // final totalTaxA = calculateTotalTax(taxA, taxConfigTaxA);
            final totalTaxB = calculateTotalTax(taxB, taxConfigTaxB);
            // final totalTaxC = calculateTotalTax(taxC, taxConfigTaxC);
            // final totalTaxD = calculateTotalTax(taxD, taxConfigTaxD);
            totalvat = totalTaxB;

            /// stop if transaction does not have customerName or customerTin
            if (transaction.customerName == null ||
                transaction.customerTin == null) {
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
                  //sarTyCd 11 is for sale
                  sarTyCd: transaction.sarTyCd ?? "11",
                  realm: localRealm!,
                  custBhfId: transaction.customerBhfId ?? "",
                  totalSupplyPrice: transaction.subTotal,
                  totalvat: totalvat,
                  totalAmount: transaction.subTotal,
                  remark: transaction.remark ?? "",
                  ocrnDt: DateTime.parse(
                      transaction.updatedAt ?? DateTime.now().toString()),
                  URI: URI);

              if (response.resultCd == "000") {
                sendPort.send(
                    'notification:${response.resultMsg}:transaction:${transaction.id.toString()}');
              } else {
                sendPort.send('notification:${response.resultMsg}}');
              }
              print(response);
            } catch (e) {}
          }

          List<Stock> stocks =
              localRealm!.query<Stock>(r'ebmSynced ==$0', [false]).toList();

          // // Fetching all variant ids from stocks
          List<int?> variantIds =
              stocks.map((stock) => stock.variantId).toList();
          Map<int, Variant?> variantMap = {};
          localRealm!
              .query<Variant>(r'id IN $0', [variantIds]).forEach((variant) {
            variantMap[variant.id!] = variant;
          });
          for (Stock stock in stocks) {
            if (!stock.ebmSynced) {
              //     // Accessing variant from the pre-fetched map
              Variant? variant = variantMap[stock.variantId];
              if (variant == null) {
                continue;
              }

              try {
                IStock iStock = IStock(
                  id: stock.id,
                  currentStock: stock.currentStock,
                );
                IVariant iVariant =
                    IVariant.fromJson(variant.toEJson().toFlipperJson());

                final response = await RWTax().saveStockMaster(
                    stock: iStock, variant: iVariant, URI: URI);
                if (response.resultCd == "000") {
                  sendPort.send(
                      'notification:${response.resultMsg}:stock:${stock.id.toString()}');
                } else {
                  sendPort.send('notification:${response.resultMsg}}');
                }
              } catch (e, s) {
                talker.error(s);
              }
            }
          }

          List<Variant> variants =
              localRealm!.query<Variant>(r'ebmSynced == $0', [false]).toList();

          for (Variant variant in variants) {
            try {
              IVariant iVariant =
                  IVariant.fromJson(variant.toEJson().toFlipperJson());

              iVariant.isrcAplcbYn = variant.isrcAplcbYn?.isEmpty ?? true
                  ? "N"
                  : variant.isrcAplcbYn;

              /// do not attempt saving a variant with missing fields
              if (variant.qtyUnitCd == null ||
                  variant.taxTyCd == null ||
                  variant.bhfId == null ||
                  variant.bhfId!.isEmpty) return;
              final response =
                  await RWTax().saveItem(variation: iVariant, URI: URI);

              if (response.resultCd == "000") {
                sendPort.send(
                    'notification:${response.resultMsg}:variant:${variant.id.toString()}');
              } else {
                sendPort.send('notification:${response.resultMsg}}');
              }
            } catch (e, s) {
              talker.error(s);
            }
          }

          // load all customer
          List<Customer> customers = localRealm!
              .query<Customer>(r'branchId ==$0', [branchId]).toList();

          for (Customer customer in customers) {
            if (!customer.ebmSynced) {
              try {
                localRealm!.write(() {
                  // Update customer properties within the write transaction
                  customer.tin = tinNumber;
                  customer.bhfId = bhfId;
                });

                if ((customer.custTin?.length ?? 0) < 9) return;
                ICustomer iCustomer =
                    ICustomer.fromJson(customer.toEJson().toFlipperJson());

                final response =
                    await RWTax().saveCustomer(customer: iCustomer, URI: URI);
                if (response.resultCd == "000") {
                  sendPort.send(
                      'notification:${response.resultMsg.substring(0, 10)}:customer:${customer.id.toString()}');
                } else {
                  sendPort.send('notification:${response.resultMsg}}');
                }
              } catch (e) {}
            }
          }
        }
      }
    });
  }

  static LocalConfiguration localConfig(
    List<int> encryptionKey,
    String dbPatch,
  ) {
    final config = Configuration.local(
      localModels,
      encryptionKey: encryptionKey,
      path: dbPatch,
      schemaVersion: schemaVersion,
      migrationCallback: (migration, oldSchemaVersion) {
        if (oldSchemaVersion < 2) {
          // This means we are migrating from version 1 to version 2
          migration.deleteType('Drawers');
        }
        if (oldSchemaVersion < 7) {
          // This means we are migrating from version 1 to version 2
          migration.deleteType('Log');
        }
      },
    );
    return config;
  }

  static Future<void> localData(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    // final sendPort = args[1] as SendPort;
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
    LocalConfiguration config = localConfig(encryptionKey, dbPatch);
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    DartPluginRegistrant.ensureInitialized();

    localRealm = Realm(config);
    // List<UnversalProduct> codes = localRealm!
    //     .query<UnversalProduct>(r'branchId==$0', [branchId]).toList();
    // if (codes.isEmpty) {
    //   final Completer<void> completer = Completer<void>();
    //   Timer(Duration(seconds: 5), () {
    //     if (!completer.isCompleted) {
    //       sendPort.send(1);
    //     }
    //   });
    //   print("Empty code fetching now");
    //   // fetchDataAndSaveUniversalProducts(businessId, branchId, URI, bhfid);
    //   sendPort.send(1);
    //   completer.complete();
    // }
  }

  // Function to fetch data from the URL endpoint
  static Future<void> fetchDataAndSaveUniversalProducts(
      int businessId, int branchId, String URI, String bhfid) async {
    final talker = TalkerFlutter.init();
    try {
      Business business =
          localRealm!.query<Business>(r'serverId == $0', [businessId]).first;

      final url = URI + "/itemClass/selectItemsClass";
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "tin": business.tinNumber,
        "bhfId": bhfid,

        ///TODO: change this date to a working date in production
        "lastReqDt": "20190523000000",
      });
      print("Loading item codes");
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);

        // Check if the response contains the data and itemClsList
        if (jsonResponse['data'] != null &&
            jsonResponse['data']['itemClsList'] != null) {
          final List<dynamic> itemClsList = jsonResponse['data']['itemClsList'];

          // Loop through the itemClsList and print the itemClsNm (name)
          for (var item in itemClsList) {
            final UniversalProduct product = UniversalProduct.fromJson(item);
            UnversalProduct? uni = localRealm!.query<UnversalProduct>(
                r'itemClsCd == $0', [product.itemClsCd]).firstOrNull;
            if (uni == null) {
              // talker.info("Now saving universal");
              localRealm!.write(() {
                localRealm!.add(
                  UnversalProduct(
                    ObjectId(),
                    id: randomNumber(),
                    itemClsCd: product.itemClsCd,
                    itemClsLvl: product.itemClsLvl,
                    itemClsNm: product.itemClsNm,
                    branchId: branchId,
                    businessId: businessId,
                    useYn: product.useYn,
                    mjrTgYn: product.mjrTgYn,
                    taxTyCd: product.taxTyCd,
                  ),
                );
              });
            }
          }
        } else {
          print('No data found in the response.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

  /// handle properties added later as the app grow but needed to support old clients
  static void _selfHeal({Realm? localRealm}) {
    // Query stocks where sold == 0.0
    List<Stock> stocks = localRealm!.query<Stock>(r'variant == NULL').toList();

    // Loop through each stock to calculate and update sold quantity
    for (Stock stock in stocks) {
      // Query past transaction items for the stock's variant
      Variant? variant =
          localRealm.query<Variant>(r'id == $0', [stock.variantId]).firstOrNull;

      // Write updated sold quantity to realm
      localRealm.write(() {
        if (variant != null) {
          stock.variant = variant;
          print("Healed Stock: ${stock.id}");
        }
      });
    }

    /// query stock with variant null assign it

    List<Variant> vVariants =
        localRealm.query<Variant>(r'productName == NULL').toList();
    for (Variant variant in vVariants) {
      Product? product = localRealm
          .query<Product>(r'id == $0', [variant.productId]).firstOrNull;
      if (product != null) {
        localRealm.write(() {
          print("healedProductName: ${variant.id}");
          variant.productName = product.name;
        });
      }
    }

    /// first find any variant with empty itemClsCd add defaults
    List<Variant> variants = localRealm
        .query<Variant>(r'itemClsCd == null OR itemClsCd == ""')
        .toList();

    for (Variant variant in variants) {
      localRealm.write(() {
        variant.itemClsCd = "5020230602";
      });
    }

    List<TransactionItem> items = localRealm
        .query<TransactionItem>(r'itemClsCd == null OR itemClsCd == ""')
        .toList();
    for (TransactionItem item in items) {
      localRealm.write(() {
        item.itemClsCd = "5020230602";
      });
    }

    /// track variant without stock and match them with stock

    List<Variant> variantsall = localRealm.all<Variant>().toList();

    for (Variant variant in variantsall) {
      final stock =
          localRealm.query<Stock>(r'variantId == $0', [variant.id]).firstOrNull;
      if (stock == null) {
        print("healed Stock: ${variant.id}");
        localRealm.write(() {
          final newStock = Stock(
            ObjectId(),
            id: randomNumber(),
            lastTouched: DateTime.now(),
            branchId: variant.branchId,
            variantId: variant.id!,
            retailPrice: variant.retailPrice,
            supplyPrice: variant.supplyPrice,
            currentStock: variant.qty,
            rsdQty: variant.qty,
            ebmSynced: false,
            value: (variant.qty * variant.retailPrice).toDouble(),
            productId: variant.productId,
            active: false,
          );
          localRealm.add(newStock);
        });
      }
    }

    /// Loop through Configuration and remove any duplicate configuration found e.g there should be one Conciguration.taxType
    List<Configurations> configurations =
        localRealm.all<Configurations>().toList();
    Set<String> uniqueTaxTypes = {};

    for (Configurations config in configurations) {
      if (!uniqueTaxTypes.contains(config.taxType!)) {
        uniqueTaxTypes.add(config.taxType!);
      } else {
        localRealm.write(() {
          localRealm.delete(config);
          print("Deleted unnessary taxes");
        });
      }
    }

    List<EBM> ebms = localRealm.all<EBM>().toList();
    Set<String> uniqueEbms = {};

    for (EBM config in ebms) {
      if (!uniqueEbms.contains(config.branchId.toString())) {
        uniqueEbms.add(config.branchId.toString());
      } else {
        localRealm.write(() {
          localRealm.delete(config);
          print("Deleted ebm config");
        });
      }
    }
    List<Variant> variantsAll = localRealm.all<Variant>().toList();
    List<ITransaction> transactions = localRealm.all<ITransaction>().toList();
    for (ITransaction transaction in transactions) {
      // find equivalent transactionRecord
      final TransactionPaymentRecord? record = localRealm
          .query<TransactionPaymentRecord>(
              r'transactionId == $0', [transaction.id]).firstOrNull;
      if (record == null) {
        localRealm.write(() {
          localRealm.add<TransactionPaymentRecord>(TransactionPaymentRecord(
            ObjectId(),
            amount: transaction.cashReceived,
            transactionId: transaction.id!,
            paymentMethod: transaction.paymentType,
          ));
        });
      }
    }

    List<Stock> stockss =
        localRealm.query<Stock>(r'initialStock == NULL').toList();

    for (Stock stock in stockss) {
      // find equivalent transactionRecord
      if (stock.initialStock == null) {
        localRealm.write(() {
          stock.initialStock = stock.currentStock;
        });
      }
    }

    /// check for variant that do not have stock assigned asign it
    for (Variant variant in variantsAll) {
      if (variant.stock == null) {
        /// find stock assign it
        Stock? stock = localRealm.query<Stock>(
            r'variantId ==$0 && branchId == $1',
            [variant.id, variant.branchId]).firstOrNull;
        if (stock != null) {
          localRealm.write(() {
            variant.stock = stock;
            print("Updated stock");
          });
        } else {
          localRealm.write(() {
            final id = randomNumber();
            localRealm.add(
              Stock(
                ObjectId(),
                id: id,
                variant: variant,
                lastTouched: DateTime.now(),
                branchId: variant.branchId,
                variantId: variant.id!,
                retailPrice: variant.retailPrice,
                supplyPrice: variant.supplyPrice,
                currentStock: variant.qty,
                rsdQty: variant.qty,
                value: (variant.qty * (variant.retailPrice)).toDouble(),
                productId: variant.productId,
                active: false,
              ),
            );
            // get created stock
            final stock =
                localRealm.query<Stock>(r'id == $0', [id]).firstOrNull;
            variant.stock = stock;
          });
        }
      }
    }
  }
}
