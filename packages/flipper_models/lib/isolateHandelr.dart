import 'dart:convert';
import 'dart:isolate';

import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/helperModels/UniversalProduct.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';

import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

mixin IsolateHandler {
  static Realm? realm;
  static Realm? localRealm;
  static Future<void> flexibleSync(List<dynamic> args) async {
    String? dbPatch = args[3] as String?;
    String? key = args[4] as String?;

    if (dbPatch == null || key == null) return;
    List<int> encryptionKey = key.toIntList();

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        flexibleConfig(user, encryptionKey, dbPatch);

    final realm = Realm(config);

    await realm.subscriptions.waitForSynchronization();
  }

  static Future<void> handleEBMTrigger(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final dbPatch = args[3] as String;
    final branchId = args[2] as int;
    String? encryptionKey = args[4] as String?;
    int? tinNumber = args[5] as int?;
    String? bhfId = args[6] as String?;
    String? URI = args[8] as String?;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    if (encryptionKey == null ||
        tinNumber == null ||
        bhfId == null ||
        URI == null) return;

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        flexibleConfig(user, encryptionKey.toIntList(), dbPatch);

    realm?.close();
    realm = Realm(config);
    bool anythingUpdated = false;

    /// handle missing value, part of self healing
    _selfHeal(realm: realm);

    // await syncUnsynced(args);
    //log("This Track how often an isolate is running, helpful when we are crashing! ${branchId}");
    // load all variants
    List<Variant> variants = realm!.query<Variant>(
        r'ebmSynced == $0 && branchId == $1 LIMIT(1000)',
        [false, branchId]).toList();
    final talker = TalkerFlutter.init();
    List<Variant> gvariantIds = <Variant>[];
    for (Variant variant in variants) {
      if (!variant.ebmSynced) {
        try {
          IVariant iVariant = IVariant(
            id: variant.id,
            deletedAt: variant.deletedAt,
            name: variant.name,
            color: variant.color,
            sku: variant.sku,
            productId: variant.productId,
            unit: variant.unit,
            productName: variant.productName,
            branchId: variant.branchId,
            taxName: variant.taxName,
            taxPercentage: variant.taxPercentage,
            isTaxExempted: variant.isTaxExempted,
            itemSeq: variant.itemSeq,
            isrccCd: variant.isrccCd,
            isrccNm: variant.isrccNm,
            isrcRt: variant.isrcRt,
            isrcAmt: variant.isrcAmt,
            taxTyCd: variant.taxTyCd,
            bcd: variant.bcd,
            itemClsCd: variant.itemClsCd,
            itemTyCd: variant.itemTyCd,
            itemStdNm: variant.itemStdNm,
            orgnNatCd: variant.orgnNatCd,
            pkg: variant.pkg,
            itemCd: variant.itemCd,
            pkgUnitCd: variant.pkgUnitCd,
            qtyUnitCd: variant.qtyUnitCd,
            itemNm: variant.itemNm,
            qty: variant.qty,
            prc: variant.prc,
            splyAmt: variant.splyAmt,
            tin: tinNumber,
            bhfId: bhfId,
            dftPrc: variant.dftPrc,
            addInfo: variant.addInfo,
            isrcAplcbYn: variant.isrcAplcbYn,
            useYn: variant.useYn,
            regrId: variant.regrId,
            regrNm: variant.regrNm,
            modrId: variant.modrId,
            modrNm: variant.modrNm,
            rsdQty: variant.rsdQty,
            lastTouched: variant.lastTouched,
            supplyPrice: variant.supplyPrice,
            retailPrice: variant.retailPrice,
            action: variant.action,
            spplrItemClsCd: variant.spplrItemClsCd,
            spplrItemCd: variant.spplrItemCd,
            spplrItemNm: variant.spplrItemNm,
            ebmSynced: variant.ebmSynced,
          );
          // Convert EJsonValue to JSON string
          // Clipboard.setData(ClipboardData(text: iVariant.toJson().toString()));

          /// is this variant part of the composite product then do not attempt to save to EBM server
          /// as the respective variant have been saved there already!
          // Product? product = realm!
          //     .query<Product>(r'id == $0', [variant.productId]).firstOrNull;

          /// Check if the product exists and is composite
          // if (product?.isComposite ?? false) {
          //   return; // Return early if the product is composite
          // }

          /// do not attempt saving a variant with missing fields
          if (variant.qtyUnitCd == null ||
              variant.taxTyCd == null ||
              variant.bhfId == null ||
              variant.bhfId!.isEmpty) return;
          await RWTax().saveItem(variation: iVariant, URI: URI);
          gvariantIds.add(variant);
          talker.warning("Successfully saved Item.");
          sendPort.send('variant:${variant.id}');
          anythingUpdated = true;
        } catch (e, s) {
          talker.error(s);
        }
      }
    }
    List<Stock> stocks =
        realm!.query<Stock>(r'branchId ==$0 LIMIT(1000)', [branchId]).toList();

    // // Fetching all variant ids from stocks
    List<int?> variantIds = stocks.map((stock) => stock.variantId).toList();
    Map<int, Variant?> variantMap = {};
    realm!.query<Variant>(r'id IN $0', [variantIds]).forEach((variant) {
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
          IVariant iVariant = IVariant(
            id: variant.id,
            deletedAt: variant.deletedAt,
            name: variant.name,
            color: variant.color,
            sku: variant.sku,
            productId: variant.productId,
            unit: variant.unit,
            productName: variant.productName,
            branchId: variant.branchId,
            taxName: variant.taxName,
            taxPercentage: variant.taxPercentage,
            isTaxExempted: variant.isTaxExempted,
            itemSeq: variant.itemSeq,
            isrccCd: variant.isrccCd,
            isrccNm: variant.isrccNm,
            isrcRt: variant.isrcRt,
            isrcAmt: variant.isrcAmt,
            taxTyCd: variant.taxTyCd,
            bcd: variant.bcd,
            itemClsCd: variant.itemClsCd,
            itemTyCd: variant.itemTyCd,
            itemStdNm: variant.itemStdNm,
            orgnNatCd: variant.orgnNatCd,
            pkg: variant.pkg,
            itemCd: variant.itemCd,
            pkgUnitCd: variant.pkgUnitCd,
            qtyUnitCd: variant.qtyUnitCd,
            itemNm: variant.itemNm,
            qty: variant.qty,
            prc: variant.prc,
            splyAmt: variant.splyAmt,
            tin: tinNumber,
            bhfId: bhfId,
            dftPrc: variant.dftPrc,
            addInfo: variant.addInfo,
            isrcAplcbYn: variant.isrcAplcbYn,
            useYn: variant.useYn,
            regrId: variant.regrId,
            regrNm: variant.regrNm,
            modrId: variant.modrId,
            modrNm: variant.modrNm,
            rsdQty: variant.rsdQty,
            lastTouched: variant.lastTouched,
            supplyPrice: variant.supplyPrice,
            retailPrice: variant.retailPrice,
            action: variant.action,
            spplrItemClsCd: variant.spplrItemClsCd,
            spplrItemCd: variant.spplrItemCd,
            spplrItemNm: variant.spplrItemNm,
            ebmSynced: variant.ebmSynced,
          );

          await RWTax().saveStock(stock: iStock, variant: iVariant, URI: URI);
          sendPort.send('stock:${stock.id}');
          talker.warning("Successfully saved Stock.");
          anythingUpdated = true;
        } catch (e, s) {
          talker.error(s);
        }
      }
    }

    // load all customer
    List<Customer> customers =
        realm!.query<Customer>(r'branchId ==$0', [branchId]).toList();

    for (Customer customer in customers) {
      if (!customer.ebmSynced) {
        try {
          realm!.write(() {
            // Update customer properties within the write transaction
            customer.tin = tinNumber;
            customer.bhfId = bhfId;
          });
          talker.info("saving Customer on EBM server ${customer.toEJson()}");
          if ((customer.custTin?.length ?? 0) < 9) return;
          ICustomer iCustomer = ICustomer(
            id: customer.id,
            custNm: customer.custNm,
            email: customer.email,
            telNo: customer.telNo,
            adrs: customer.adrs,
            branchId: customer.branchId,
            updatedAt: customer.updatedAt,
            custNo: customer.custNo,
            custTin: customer.custTin,
            regrNm: customer.regrNm,
            regrId: customer.regrId,
            modrNm: customer.modrNm,
            modrId: customer.modrId,
            ebmSynced: customer.ebmSynced,
            lastTouched: customer.lastTouched,
            action: customer.action,
            deletedAt: customer.deletedAt,
            tin: tinNumber,
            bhfId: bhfId,
            useYn: customer.useYn,
            customerType: customer.customerType,
          );

          await RWTax().saveCustomer(customer: iCustomer, URI: URI);
          sendPort.send('customer:${customer.id}');
          anythingUpdated = true;
        } catch (e) {}
      }
    }

    if (anythingUpdated) {
      /// send Trigger to send notification
      sendPort.send('notification:${1}');
    }
  }

  static FlexibleSyncConfiguration flexibleConfig(
    User? user,
    List<int> encryptionKey,
    String dbPatch,
  ) {
    final config = Configuration.flexibleSync(
      user!,
      realmModels,
      encryptionKey: encryptionKey,
      path: dbPatch,
    );
    return config;
  }

  static LocalConfiguration localConfig(
    List<int> encryptionKey,
    String dbPatch,
  ) {
    final config = Configuration.local(
      [
        UserActivity.schema,
        Business.schema,
        Branch.schema,
        Drawers.schema,
        UnversalProduct.schema,
        AppNotification.schema
      ],
      encryptionKey: encryptionKey,
      path: dbPatch,
      schemaVersion: 2,
      migrationCallback: (migration, oldSchemaVersion) {
        if (oldSchemaVersion < 2) {
          // This means we are migrating from version 1 to version 2
          migration.deleteType('Drawers');
        }
      },
    );
    return config;
  }

  static Future<void> localData(List<dynamic> args) async {
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

    localRealm?.close();
    localRealm = Realm(config);
    final talker = TalkerFlutter.init();
    List<UnversalProduct> codes = localRealm!
        .query<UnversalProduct>(r'branchId==$0', [branchId]).toList();
    if (codes.isEmpty) {
      talker.warning("Codes empty");
      fetchDataAndSaveUniversalProducts(businessId, branchId, URI, bhfid);
    }
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
      talker.warning("Loading item codes");
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
          talker.warning('No data found in the response.');
        }
      } else {
        talker.warning(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      talker.warning('Error fetching data: $e');
    }
  }

  static void _selfHeal({Realm? realm}) {
    /// first find any variant with empty itemClsCd add defaults
    List<Variant> variants =
        realm!.query<Variant>(r'itemClsCd == null OR itemClsCd == ""').toList();
    talker.info("healed ${variants.length}");
    for (Variant variant in variants) {
      realm.write(() {
        variant.itemClsCd = "5020230602";
      });
    }

    List<TransactionItem> items = realm
        .query<TransactionItem>(r'itemClsCd == null OR itemClsCd == ""')
        .toList();
    talker.info("healed ${variants.length}");
    for (TransactionItem item in items) {
      realm.write(() {
        item.itemClsCd = "5020230602";
      });
    }
  }
}
