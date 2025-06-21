import 'dart:isolate';
import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flipper_models/firebase_options.dart';
import 'package:email_validator/email_validator.dart' as email_validator;
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

final repository = Repository();
mixin VariantPatch {
  static Future<void> patchVariant({
    required String URI,
    Function(String)? sendPort,
    String? identifier,
  }) async {
    final branchId = ProxyService.box.getBranchId()!;
    List<Variant> variants = await _getVariants(identifier, branchId);

    for (Variant variant in variants) {
      if (_shouldSkipVariant(variant)) {
        continue;
      }

      try {
        await _ensureBusinessInfo(variant);
        await updateVariantitemTyCd(variant);

        final syncSuccess = await _syncVariantWithRRA(variant, URI, sendPort);
        if (syncSuccess) {
          _handleSuccess(
            variant: variant,
            identifier: identifier,
            URI: URI,
            sendPort: sendPort,
            branchId: branchId,
          );
        } else if (sendPort != null) {
          throw Exception("Failed to sync variant with RRA");
        }
      } catch (e) {
        // Log the error for debugging. Consider more specific error handling.
        print("Error patching variant ${variant.id}: $e");
        // in case of errror be the wrong data we are passing to rra, ignore and continue.
        continue;
      }
    }
  }

  // Helper method to get variants based on identifier
  static Future<List<Variant>> _getVariants(
      String? identifier, int? branchId) async {
    if (identifier != null) {
      return await repository.get<Variant>(
          query: brick.Query(where: [
        Where('id').isExactly(identifier),
        Where('branchId').isExactly(branchId)
      ]));
    } else {
      return await repository.get<Variant>(
          query: brick.Query(where: [
        Where('ebmSynced').isExactly(false),
        Where('branchId').isExactly(branchId)
      ]));
    }
  }

  // Helper method to check if a variant should be skipped
  static bool _shouldSkipVariant(Variant variant) {
    return variant.imptItemSttsCd == "2" || variant.pchsSttsCd == "01";
  }

  // Helper method to ensure business info is populated
  static Future<void> _ensureBusinessInfo(Variant variant) async {
    if (variant.bhfId == null) {
      Business? business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId());
      variant.bhfId = business!.bhfId ?? "00";
      variant.tin = business.tinNumber ?? 999909695;

      await ProxyService.strategy.updateVariant(updatables: [variant]);
    }
  }

  static Future<void> _handleSuccess({
    required Variant variant,
    required String? identifier,
    required String URI,
    required Function(String)? sendPort,
    required int branchId,
  }) async {
    final serverUrl = await ProxyService.box.getServerUrl();
    final tinNumber = ProxyService.box.tin();
    final bhfId = await ProxyService.box.bhfId();

    final notificationSender = (String message) {
      ProxyService.notification.sendLocalNotification(body: message);
    };

    // Patch stock
    if (identifier != null) {
      if (variant.stock?.id != null) {
        await StockPatch.patchStock(
          identifier: variant.stock!.id,
          URI: serverUrl!,
          sendPort: notificationSender,
        );
      } else {
        await StockPatch.patchStock(
          URI: serverUrl!,
          sendPort: notificationSender,
        );
      }
    } else {
      await StockPatch.patchStock(
        URI: serverUrl!,
        sendPort: notificationSender,
      );
    }

    // Patch transaction item
    await PatchTransactionItem.patchTransactionItem(
      URI: URI,
      sendPort: notificationSender,
      tinNumber: tinNumber,
      bhfId: bhfId!,
    );

    // Patch customer
    CustomerPatch.patchCustomer(
      URI: URI,
      tinNumber: tinNumber,
      bhfId: bhfId,
      branchId: branchId,
      sendPort: notificationSender,
    );

    if (sendPort != null) {
      sendPort("Patch successful"); //Consider a better message here.
    }
    ProxyService.box.writeBool(key: 'lockPatching', value: false);
  }

  static Future<bool> _syncVariantWithRRA(
    Variant variant,
    String URI,
    Function(String)? sendPort,
  ) async {
    try {
      // First try to save the item
      final itemResponse = await RWTax().saveItem(variation: variant, URI: URI);
      if (itemResponse.resultCd != "000") {
        if (sendPort != null) {
          sendPort(itemResponse.resultMsg);
        }
        return false;
      } 
      // Then try to save the stock master
      final stockResponse =
          await RWTax().saveStockMaster(variant: variant, URI: URI);
      if (stockResponse.resultCd != "000") {
        if (sendPort != null) {
          sendPort(stockResponse.resultMsg);
        }
        return false;
      }

      // Both operations succeeded - now we can safely mark the variant as synced
      variant.ebmSynced = true;
      await repository.upsert(variant);
      return true;
    } catch (e) {
      if (sendPort != null) {
        sendPort(e.toString());
      }
      return false;
    }
  }
}
Future<void> updateVariantitemTyCd(Variant variant) async {
  if (variant.itemTyCd == null ||
      variant.itemTyCd!.trim().toLowerCase() == "" ||
      variant.itemTyCd!.trim().toLowerCase() == "null") {
    variant.itemTyCd = "2";
    try {
      await ProxyService.strategy.updateVariant(updatables: [variant]);
    } catch (e) {
      print("Error updating variant: $e");
      rethrow; // Re-throw the exception
    }
  }
}

/// should never call this independently, it should be called by the patchVariant method

mixin StockPatch {
  static Future<void> patchStock(
      {required String URI,
      Function(String)? sendPort,
      String? identifier}) async {
    List<Variant> variants = [];
    final branchId = ProxyService.box.getBranchId();
    if (identifier != null) {
      variants = await repository.get<Variant>(
          query: brick.Query(where: [
        Where('id').isExactly(identifier),
        Where('branchId').isExactly(branchId)
      ]));
    } else {
      variants = await repository.get<Variant>(
          query: brick.Query(where: [
        Where('ebmSynced').isExactly(false),
        Where('branchId').isExactly(branchId)
      ]));
    }
    // filter out variants with
    for (Variant variant in variants) {
      if (variant.imptItemSttsCd == "2" || variant.pchsSttsCd == "01") {
        continue;
      }
      if (!variant.ebmSynced!) {
        try {
          Business? business = await ProxyService.strategy
              .getBusiness(businessId: ProxyService.box.getBusinessId());
          variant.bhfId = business!.bhfId ?? "00";
          variant.tin = business.tinNumber ?? 999909695;
          final response =
              await RWTax().saveStockMaster(variant: variant, URI: URI);
          if (response.resultCd == "000" && sendPort != null) {
            sendPort(response.resultMsg);
          } else if (sendPort != null) {
            throw Exception(response.resultMsg);
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
      String? identifier,
      required String bhfId}) async {
    final branchId = ProxyService.box.getBranchId();
    final transactions = await repository.get<ITransaction>(
        query: brick.Query(
            where: identifier != null
                ? [
                    Where('id').isExactly(identifier),
                  ]
                : [
                    Where('ebmSynced').isExactly(false),
                    Where('status').isExactly(COMPLETE),
                    Or('status').isExactly(PARKED),
                    Where('customerName').isNot(null),
                    Where('customerTin').isNot(null),
                    Where('branchId').isExactly(branchId)
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

      if (transaction.customerName == null ||
          transaction.customerTin == null ||
          transaction.sarNo == null ||
          transaction.receiptType == "TS" ||
          transaction.receiptType == "PS" ||
          transaction.ebmSynced!) {
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
            ocrnDt: transaction.updatedAt ?? DateTime.now().toUtc(),
            URI: URI);

        if (response.resultCd == "000") {
          sendPort('${transaction.sarNo}:${response.resultMsg}');

          transaction.ebmSynced = true;
          await repository.upsert(transaction);
        } else {
          /// if for some reason we fail ignore this forever
          transaction.ebmSynced = true;
          await repository.upsert(transaction);
          sendPort(response.resultMsg);
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
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(where: [Where('branchId').isExactly(branchId)]));

    for (Customer customer in customers) {
      if (!customer.ebmSynced!) {
        try {
          customer.bhfId = bhfId;
          repository.upsert(customer);

          if ((customer.custTin?.length ?? 0) < 9) return;
          ICustomer iCustomer = ICustomer.fromJson(customer.toJson());

          final response =
              await RWTax().saveCustomer(customer: iCustomer, URI: URI);
          if (response.resultCd == "000") {
            customer.ebmSynced = true;
            repository.upsert(customer);
            sendPort('Customer Synced: ${customer.id.substring(0, 3)}');
          } else {
            /// check if customer.email is valid using email_validator: ^2.1.17 if not then generate random email
            /// this is because we do not want to add hussle to a user to create valid email
            if (customer.email == null ||
                !email_validator.EmailValidator.validate(customer.email!)) {
              customer.email = "${customer.id.substring(0, 3)}@flipper.com";
              repository.upsert(customer);
            }
            GlobalErrorHandler.logError(
              'Customer Sync Failed: ${customer.email}',
              type: "tax_error",
              context: {
                'resultCode': response.resultMsg,
                'businessId': ProxyService.box.getBusinessId(),
                'timestamp': DateTime.now().toIso8601String(),
              },
            );
            sendPort('Customer Sync Failed: ${customer.email}');
          }
        } catch (e) {
          talker.error(e);
        }
      }
    }
  }
}

class IsolateHandler with StockPatch {
  static Future<void> clearFirestoreCache() async {
    try {
      // await FirebaseFirestore.instance.clearPersistence();
    } catch (e) {}
  }

  static Future<void> handler(List<dynamic> args) async {
    final SendPort sendPort = args[0];
    final RootIsolateToken rootIsolateToken = args[1];
    // final RealmInterface strategy = args[2];

    DartPluginRegistrant.ensureInitialized();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    ReceivePort port = ReceivePort();

    sendPort.send(port.sendPort);
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    port.listen((message) async {
      if (message is Map<String, dynamic>) {
        if (message['task'] == 'taxService') {
          // List<Customer> customers = await strategy.customers(branchId: 1);
          // print("customers from isolate: ${customers.length}");
          print("dealing with isolate");
          // int branchId = message['branchId'];

          // int businessId = message['businessId'];
          // String dbPath = message['dbPath'] ?? "";
          // String? URI = message['URI'];
          // String? bhfId = message['bhfId'];
        }
      }
    });
  }
}
