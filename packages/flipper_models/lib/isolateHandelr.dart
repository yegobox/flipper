import 'dart:isolate';

import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/secrets.dart';

import 'package:realm/realm.dart';

import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

mixin IsolateHandler {
  static Future<void> syncUnsynced(List<dynamic> args) async {
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = Realm(config);

    await realm.subscriptions.waitForSynchronization();
  }

  static Future<void> handleEBMTrigger(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final dbPatch = args[3] as String;
    String encryptionKey = args[4] as String;
    int tinNumber = args[5] as int;
    String bhfId = args[6] as String;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey.toIntList(), dbPatch);

    final realm = Realm(config);

    await syncUnsynced(args);

    // load all variants
    List<Variant> variants = realm.all<Variant>().toList();
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
          Clipboard.setData(ClipboardData(text: iVariant.toJson().toString()));

          await RWTax().saveItem(variation: iVariant);
          gvariantIds.add(variant);
          talker.warning("Successfully saved Item.");
          sendPort.send('variant:${variant.id}');
        } catch (e, s) {
          talker.error(s);
        }
      }
    }
    List<Stock> stocks = realm.all<Stock>().toList();

    // Fetching all variant ids from stocks
    List<int?> variantIds = stocks.map((stock) => stock.variantId).toList();
    Map<int, Variant?> variantMap = {};
    realm.query<Variant>(r'id IN $0', [variantIds]).forEach((variant) {
      variantMap[variant.id!] = variant;
    });
    for (Stock stock in stocks) {
      if (!stock.ebmSynced) {
        // Accessing variant from the pre-fetched map
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

          await RWTax().saveStock(stock: iStock, variant: iVariant);
          sendPort.send('stock:${stock.id}');
          talker.warning("Successfully saved Stock.");
        } catch (e, s) {
          talker.error(s);
        }
      }
    }

    // load all customer
    List<Customer> customers = realm.all<Customer>().toList();

    for (Customer customer in customers) {
      if (!customer.ebmSynced) {
        try {
          customer.tin = tinNumber;
          customer.bhfId = bhfId;
          talker.info("saving Customer on EBM server ${customer.toEJson()}");

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
            tin: customer.tin,
            bhfId: customer.bhfId,
            useYn: customer.useYn,
            customerType: customer.customerType,
          );

          await RWTax().saveCustomer(customer: iCustomer);
          sendPort.send('customer:${customer.id}');
        } catch (e) {}
      }
    }
  }

  static FlexibleSyncConfiguration realmConfig(
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
}
