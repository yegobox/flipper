// ignore: unused_import
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/mocks.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cognito;

import 'package:talker_flutter/talker_flutter.dart';

// This issue describe how I can mark something for completion later
// https://github.com/realm/realm-dart/issues/1203

class RealmAPI<M extends IJsonSerializable>
    implements SyncReaml<M>, RealmApiInterface {
  @override
  Realm? realm;
  final talker = TalkerFlutter.init();
  late String apihub;
  late String commApi;

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) async {
    DateTime oldDate;
    DateTime temporaryDate;

    if (period == 'Today') {
      DateTime tempToday = DateTime.now();
      oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
    } else if (period == 'This Week') {
      oldDate = DateTime.now().subtract(Duration(days: 7));
    } else if (period == 'This Month') {
      oldDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      oldDate = DateTime.now().subtract(Duration(days: 365));
    }

    List<ITransaction> transactionsList = transactions();

    List<ITransaction> filteredTransactions = [];
    for (final transaction in transactionsList) {
      temporaryDate = DateTime.parse(transaction.createdAt!);
      if (temporaryDate.isAfter(oldDate)) {
        filteredTransactions.add(transaction);
      }
    }

    double sum_cash_in = 0;
    double sum_cash_out = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.transactionType == 'Cash Out') {
        sum_cash_out = transaction.subTotal + sum_cash_out;
      } else {
        sum_cash_in = transaction.subTotal + sum_cash_in;
      }
    }

    return (income: sum_cash_in, expense: sum_cash_out);
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
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments) {
    if (realm == null) return null;
    final results = realm!.query<T>(query, arguments);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  @override
  Category? activeCategory({required int branchId}) {
    return realm!.query<Category>(
        r'focused == $0 && active == $1 && branchId == $2',
        [true, true, branchId]).firstOrNull;
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId}) async {
    try {
      // Open a write transaction

      // Add the customer to the Realm
      realm!.put(customer);

      // Get the transaction from Realm
      final transaction =
          realm!.all<ITransaction>().firstWhere((t) => t.id == transactionId);

      realm!.write(() {
        // Update the transaction with the customer ID
        transaction.customerId = customer.id;
      });
      return realm!.query<Customer>(r'id == $0', [customer.id]).first;
    } catch (e) {
      print('Failed to add customer: $e');
      rethrow;
    }
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    try {
      final fav = realm!.query<Favorite>(
          r'favIndex == $0 && deletedAt == nil', [data.favIndex!]).firstOrNull;

      if (fav == null) {
        data.id = randomNumber();

        realm!.put<Favorite>(data);

        return 200;
      } else {
        await realm!.write(() {
          fav.productId = data.productId;
        });
        return 200;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) async {
    Stock stock = Stock(ObjectId(),
        retailPrice: variant.retailPrice,
        supplyPrice: variant.supplyPrice,
        id: randomNumber(),
        productId: variant.productId,
        variantId: variant.id,
        branchId: variant.branchId);
    try {
      realm!.put<Stock>(stock);

      return stock;
    } catch (e) {
      print('Error adding stock to variant: $e');
      rethrow;
    }
  }

  @override
  void addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) {
    // Add the new item to the database
    realm!.write(() {
      realm!.add<TransactionItem>(item);
    });

    /// update this item to know if it is involved in the composition
    /// so it will be treated differently on cart.

    // Fetch all items
    var allItems = realm!.query<TransactionItem>(
        r'transactionId ==$0', [transaction.id]).toList();

    // Sort the items if necessary
    // Assuming there's a property 'createdAt' to sort items chronologically
    allItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    // Update the itemSeq for each item
    realm!.write(() {
      for (var i = 0; i < allItems.length; i++) {
        allItems[i].itemSeq = i + 1; // itemSeq should start from 1
      }
    });

    // Save the updated items back to the database
    realm!.write(() {
      for (var updatedItem in allItems) {
        realm!.add<TransactionItem>(updatedItem);
      }
    });
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      final unitsToAdd = <IUnit>[];
      // Open a write transaction
      for (Map map in units) {
        final unit = IUnit(ObjectId(),
            active: map['active'],
            branchId: branchId,
            id: randomNumber(),
            name: map['name'],
            action: AppActions.created,
            lastTouched: DateTime.now(),
            value: map['value']);

        // Add the unit to Realm
        unitsToAdd.add(unit);
      }
      realm!.write(() {
        realm!.addAll<IUnit>(unitsToAdd);
      });

      return 200; // Return a success code
    } catch (e) {
      print('Failed to add units: $e');
      rethrow;
    }
  }

  @override
  Future<void> assignCustomerToTransaction(
      {required int customerId, int? transactionId}) async {
    try {
      // Open a single write transaction
      realm!.write(() {
        // Get the transaction object
        final transaction = realm!
            .query<ITransaction>(r'id == $0', [transactionId]).firstOrNull;

        // Update the transaction's customerId if it exists
        if (transaction != null) {
          transaction.customerId = customerId;
        } else {
          throw Exception('Transaction with ID $transactionId not found');
        }

        // Get the customer object
        final customer =
            realm!.query<Customer>(r'id == $0', [customerId]).firstOrNull;

        // Update the customer's updatedAt if it exists
        if (customer != null) {
          customer.updatedAt = DateTime.now();
        } else {
          throw Exception('Customer with ID $customerId not found');
        }
      });
    } catch (e) {
      print('Failed to assign customer to transaction: $e');
      rethrow;
    }
  }

  @override
  Stream<Tenant?> authState({required int branchId}) async* {
    final userId = ProxyService.box.getUserId();

    if (userId == null) {
      // Handle the case where userId == null, perhaps throw an exception or return an error Stream
      throw Exception('User ID == nil');
    }

    if (realm == null) {
      // Handle the case where realm == null, perhaps throw an exception or return an error Stream
      throw Exception('Realm == nil');
    }

    final controller = StreamController<Tenant?>();

    realm!.query<Tenant>(r'userId == $0 ', [userId]).changes.listen((tenants) {
          controller
              .add(tenants.results.isEmpty ? null : tenants.results.first);
        });

    await for (var tenant in controller.stream) {
      yield tenant;
    }

    // Close the StreamController after the stream is finishe
    controller.close();
  }

  @override
  Future<bool> bindProduct(
      {required int productId, required int tenantId}) async {
    try {
      final product =
          realm!.query<Product>(r'id == $0 ', [productId]).firstOrNull;

      if (product == null) {
        // Product not found
        return false;
      }

      product.nfcEnabled = true;
      product.bindedToTenantId = tenantId;

      // realm!.write(() {
      //   realm!.put<Product>(product);
      // });

      return true;
    } catch (error) {
      // Handle error during binding process
      return false;
    }
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    //  return  realm!categorys.filter().branchIdEqualTo(branchId).findAll();
    return realm!.query<Category>(r'branchId == $0 ', [branchId]).toList();
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

  /// an experimental to call the mongo db api directly via api
  /// to get changes as subscribing to the change is not getting
  /// data to the device in time we think!

  @override
  void close() {
    if (realm == null) return null;
    realm!.close();
    realm = null;
  }

  @override
  ITransaction collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType,
      required bool isIncome,
      required double discount,
      String? categoryId,
      required String transactionType,
      bool directlyHandleReceipt = true}) {
    try {
      List<TransactionItem> items = transactionItems(
          transactionId: transaction.id!,
          doneWithTransaction: false,
          active: true);
      realm!.write(() {
        transaction.lastTouched = DateTime.now().toUtc().toLocal();
        transaction.status = COMPLETE;
        transaction.isIncome = isIncome;
        transaction.isExpense = !isIncome;
        double subTotal = items.fold(0, (num a, b) => a + (b.price * b.qty));

        /// if we are dealing with expenses then subTotal equal to the amount received
        final subTotalFinalied = !isIncome ? cashReceived : subTotal;
        transaction.customerChangeDue = (cashReceived - subTotalFinalied);
        transaction.paymentType = paymentType;
        transaction.cashReceived = cashReceived;

        transaction.subTotal = subTotalFinalied;

        /// for now receipt type to be printed is in box shared preference
        /// this ofcause has limitation that if more than two users are using device
        /// one user will use configuration set by probably a different user, this need to change soon.
        String receiptType = TransactionReceptType.NS;
        if (ProxyService.box.isPoroformaMode()) {
          receiptType = TransactionReceptType.PS;
        }
        if (ProxyService.box.isTrainingMode()) {
          receiptType = TransactionReceptType.TS;
        }
        transaction.receiptType = receiptType;

        /// refresh created as well to reflect when this transaction was created and completed

        transaction.updatedAt =
            DateTime.now().toUtc().toLocal().toIso8601String();
        transaction.createdAt =
            DateTime.now().toUtc().toLocal().toIso8601String();
        transaction.transactionType = transactionType;
        transaction.categoryId = categoryId ?? "0";
      });

      try {
        for (TransactionItem item in items) {
          /// because there might case where we have non-active transactionItem in the list of
          /// TransactionItem, then we remove it first before completing the transaction
          if (!item.active!) {
            realm!.delete(item);
          }
          talker.warning("VariantSoldId for debug: ${item.variantId!}");
          Stock? stock = stockByVariantId(variantId: item.variantId!);
          final finalStock = (stock!.currentStock - item.qty);
          realm!.write(() {
            item.dcAmt = discount;
            item.discount = discount;
            item.lastTouched = DateTime.now().toUtc().toLocal();

            stock.currentStock = finalStock;
            stock.rsdQty = finalStock;
            // stock value after item deduct
            stock.value = finalStock * (stock.retailPrice);
            stock.action = AppActions.updated;
            stock.ebmSynced = false;
            stock.bhfId = stock.bhfId ?? ProxyService.box.bhfId();
            stock.tin = stock.tin ?? ProxyService.box.tin();
          });
          realm!.write(() {
            item.doneWithTransaction = true;
            item.updatedAt = DateTime.now().toUtc().toLocal().toIso8601String();
          });

          /// search the related product and touch them to make them as most used
          /// hence why we are adding time to it
          Variant? variant = getVariantById(id: item.variantId!);
          Product? product = getProduct(id: variant!.productId!);
          if (product != null) {
            realm!.write(() {
              product.lastTouched = DateTime.now().toUtc().toLocal();
            });
          }
        }
      } catch (e, s) {
        talker.error(s);
      }

      // remove currentTransactionId from local storage to leave a room
      // for listening to new transaction that will be created
      ProxyService.box.remove(key: 'currentTransactionId');
      //NOTE: trigger EBM, now
      if (directlyHandleReceipt) {
        TaxController(object: transaction)
            .handleReceipt(printCallback: (Uint8List bytes) {});
      }
      return transaction;
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return realm!.query<PColor>(r'branchId == $0 ', [branchId]).toList();
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) async {
    return realm!.query<ITransaction>(
        r'status == $0 && branchId == $1', [COMPLETE, branchId]).toList();
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
    /// update user activity model

    if (data is Counter) {
      Counter counter = data;

      realm!.put<Counter>(counter);
      // Return the created conversation
      // Cast the result to type T
      return data;
    }

    /// end with updating user activity
    if (data is Conversation) {
      Conversation conversation = data;

      realm!.put<Conversation>(conversation);
      // Return the created conversation
      // Cast the result to type T
      return data;
    }

    if (data is PColor) {
      final colorsToAdd = <PColor>[];
      PColor color = data;
      for (String colorName in data.colors) {
        colorsToAdd.add(PColor(ObjectId(),
            id: randomNumber(),
            lastTouched: DateTime.now(),
            action: AppActions.created,
            name: colorName,
            active: color.active,
            branchId: color.branchId));
      }
      realm!.write(() => realm!.addAll(colorsToAdd));
    }
    if (data is Device) {
      Device device = data;
      realm!.write(() {
        realm!.add<Device>(device);
      });
      return null;
    }
    if (data is Conversation) {
      Conversation conversation = data;
      realm!.put<Conversation>(conversation);
      return null;
    }
    if (data is Category) {
      Category category = data;
      realm!.put<Category>(category);
      return null;
    }
    if (data is Product) {
      realm!.put<Product>(data);
    }
    if (data is Variant) {
      realm!.put<Variant>(data);
      return null;
    }
    if (data is Favorite) {
      realm!.put<Favorite>(data);
      return null;
    }
    if (data is Stock) {
      realm!.put<Stock>(data);
      return null;
    }

    if (data is Token) {
      realm!.put<Token>(data);
      return null;
    }
    if (data is Setting) {
      realm!.write(() {
        realm!.put<Setting>(data);
      });
      return null;
    }
    if (data is EBM) {
      realm!.put<EBM>(data);
      return null;
    }
    if (data is ITransaction) {
      realm!.put<ITransaction>(data);
      return null;
    }
    if (data is TransactionItem) {
      realm!.put<TransactionItem>(data);
      return null;
    }
    return null;
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) {
    // TODO: implement createGoogleSheetDoc
    throw UnimplementedError();
  }

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false}) async {
    // Check if the product created (custom or temp) already exists and return it
    final String productName = product.name!;
    if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
      final Product? existingProduct = await _findProductByBusinessId(
          name: productName, businessId: businessId);
      if (existingProduct != null) {
        return existingProduct;
      }
    }

    await realm!.putAsync<Product>(product);

    if (!skipRegularVariant) {
      Product kProduct =
          realm!.query<Product>(r'id == $0 ', [product.id]).first;

      // Create a Regular Variant
      final Variant newVariant = _createRegularVariant(branchId, tinNumber,
          qty: qty,
          product: product,
          supplierPrice: supplyPrice,
          retailPrice: retailPrice,
          name: product.name!,
          sku: _getSku(branchId: branchId)!.sku.toString(),
          productId: product.id!,
          itemSeq: itemSeq,
          ebmSynced: ebmSynced);
      await realm!.putAsync<Variant>(newVariant);

      // Create a Stock for the Regular Variant
      final Stock stock = Stock(ObjectId(),
          lastTouched: DateTime.now(),
          id: randomNumber(),
          action: 'create',
          branchId: branchId,
          variantId: newVariant.id!,
          currentStock: qty,
          productId: kProduct.id!);
      await realm!.putAsync<Stock>(stock);
    }

    return realm!.query<Product>(r'id == $0 ', [product.id]).firstOrNull;
  }

  @override
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter}) async {
    int branchId = ProxyService.box.getBranchId()!;

    Receipt receipt = Receipt(ObjectId(),
        id: randomNumber(),
        // Consider using a more robust ID generation
        branchId: branchId,
        resultCd: signature.resultCd,
        resultMsg: signature.resultMsg,
        rcptNo: signature.data?.rcptNo ?? 0,
        intrlData: signature.data?.intrlData ?? "",
        rcptSign: signature.data?.rcptSign ?? "",
        qrCode: qrCode,
        receiptType: receiptType,
        vsdcRcptPbctDate: signature.data?.vsdcRcptPbctDate ?? "",
        sdcId: signature.data?.sdcId ?? "",
        totRcptNo: signature.data?.totRcptNo ?? 0,
        mrcNo: signature.data?.mrcNo ?? "",
        transactionId: transaction.id!,
        invcNo: counter.invcNo,
        resultDt: signature.resultDt ?? "");

    try {
      realm!.write(() => realm!.add<Receipt>(receipt));

      return receipt;
    } catch (error, s) {
      // Handle error during write operation
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) {
    // TODO: implement createSetting
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> customers({required int branchId}) async {
    return realm!.query<Customer>(r'branchId == $0 ', [branchId]).toList();
  }

  FlipperHttpClient flipperHttpClient = FlipperHttpClient(http.Client());

  @override
  Future<bool> delete({required int id, String? endPoint}) async {
    switch (endPoint) {
      case 'color':
        PColor color = realm!.query<PColor>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.delete(color);
        });
        break;
      case 'device':
        realm!.write(() {
          Device device = realm!.query<Device>(r'id == $0 ', [id]).first;
          realm!.write(() {
            realm!.delete(device);
          });
          return false;
        });
        break;
      case 'category':
        Category category = realm!.query<Category>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(category);
        });
        break;
      case 'product':
        Product? product =
            realm!.query<Product>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          if (product != null) {
            realm!.delete(product);
          }
        });
        break;
      case 'variant':
        Variant variant = realm!.query<Variant>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(variant);
        });
        break;
      case 'stock':
        Stock? stock = realm!.query<Stock>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(stock);
        });
        break;
      case 'setting':
        Setting setting = realm!.query<Setting>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(setting);
        });
        break;
      case 'pin':
        Pin? pin = realm!.query<Pin>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.delete(pin);
        });
        break;
      case 'business':
        final business = realm!.query<Business>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.delete(business!);
        });
        break;
      case 'branch':
        final business = realm!.query<Branch>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.delete(business!);
        });
        break;

      case 'voucher':
        final business = realm!.query<Voucher>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.delete(business!);
        });
        break;
      case 'transactionItem':
        TransactionItem? transactionItem =
            realm!.query<TransactionItem>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.delete(transactionItem);
        });
        break;
      case 'customer':
        Customer? customer = realm!.query<Customer>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(customer);
        });
        break;
      case 'tenant':
        final response = await flipperHttpClient
            .delete(Uri.parse("$apihub/v2/api/tenant/${id}"));
        if (response.statusCode == 200) {
          Tenant? tenant = realm!.query<Tenant>(r'id == $0 ', [id]).firstOrNull;
          realm!.write(() {
            realm!.delete(tenant!);
          });
        }
        break;
      case 'assets':
        Assets? asset = realm!.query<Assets>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(asset);
        });
        break;
      case 'permission':
        LPermission? permission =
            realm!.query<LPermission>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(permission);
        });
        break;
      case 'access':
        Access? access = realm!.query<Access>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete(access);
        });
        break;
      default:
        return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  Future<void> deleteAllProducts() async {
    List<Product> products =
        await productsFuture(branchId: ProxyService.box.getBranchId()!);
    List<int> productIds = products.map((product) => product.id!).toList();
    realm!.write(() {
      realm!.deleteMany(productIds
          .map((id) => realm!.query<Product>(r'id == $0', [id]).first));
    });
  }

  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) async {
    final favorite = realm!.query<Favorite>(
        r'favIndex == $0 && deletedAt == null ', [favIndex]).first;
    realm!.write(() {
      realm!.delete<Favorite>(favorite);
    });
    return Future.value(200);
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) async {
    final transaction = realm!.query<ITransaction>(
        r'id == $0 && deletedAt == null ', [transactionIndex]).first;
    realm!.write(() {
      realm!.delete<ITransaction>(transaction);
    });
    return Future.value(200);
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
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    return realm!
        .query<Product>(r'bindedToTenantId == $0', [tenantId]).firstOrNull;
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId(
      {required int productId}) async* {
    final variants = realm!.query<Variant>(r'productId == $0', [productId]);
    variants.changes.listen((_) async* {
      yield variants.toList();
    });
  }

  @override
  Future<PColor?> getColor({required int id}) async {
    return realm!.query<PColor>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) {
    // TODO: implement getConversation
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) async {
    return realm!.query<Counter>(r'branchId == $0 AND receiptType == $1',
        [branchId, receiptType.toUpperCase()]).firstOrNull;
  }

  @override
  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
  }) async {
    /// Find product with name CUSTOM_PRODUCT
    Product? product = realm!.query<Product>(
        r'name == $0 AND branchId== $1 AND deletedAt == nil',
        [CUSTOM_PRODUCT, branchId]).firstOrNull;

    if (product == null) {
      // Create a new custom product if it doesn't exist
      product = await createProduct(
          tinNumber: tinNumber,
          branchId: branchId,
          businessId: businessId,
          product: Product(ObjectId(),
              id: randomNumber(),
              lastTouched: DateTime.now(),
              name: CUSTOM_PRODUCT,
              action: 'create',
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now().toIso8601String(),
              branchId: branchId));
    }

    /// for whatever reason if a product exist and there is no related variant please add it before we proceed.
    Variant? variant =
        realm!.query<Variant>(r'productId == $0 ', [product!.id]).firstOrNull;

    if (variant == null) {
      /// If the variant doesn't exist, add it
      variant = await _addMissingVariant(variant, product, branchId, tinNumber);
    }

    return variant;
  }

  @override
  List<Customer> getCustomers({String? key, int? id}) {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).toList();
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'custNm CONTAINS $0 OR email CONTAINS $0 OR telNo CONTAINS $0',
          [key]).toList();
      return customer;
    } else {
      return [];
    }
  }

  @override
  Customer? getCustomer({String? key, int? id}) {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).firstOrNull;
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'(custNm CONTAINS $0 OR email CONTAINS $0 OR telNo CONTAINS $0) AND deletedAt == nil',
          [key]).firstOrNull;
      return customer;
    } else {
      return null;
    }
  }

  @override
  Future<Customer?> getCustomerFuture({String? key, int? id}) async {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).firstOrNull;
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'(custNm CONTAINS $0 OR email CONTAINS $0 OR telNo CONTAINS $0) AND deletedAt == nil',
          [key]).firstOrNull;
      return customer;
    } else {
      return null;
    }
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) async* {
    realm!
        .query<Tenant>(r'businessId == $0 AND deletedAt == nil', [businessId])
        .changes
        .listen((_) async* {
          yield realm!.query<Tenant>(r'businessId == $0 AND deletedAt == nil',
              [businessId]).firstOrNull;
        });
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    // get device from realm with linking code and return it
    return realm!.query<Device>(
        r'phone == $0 AND linkingCode == $1 AND deletedAt == nil',
        [phone, linkingCode]).firstOrNull;
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    // get device from realm with id and return it
    return realm!.query<Device>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    // get device from realm with linking code and return it
    return realm!.query<Device>(
        r'businessId == $0 AND deletedAt == nil', [businessId]).toList();
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) async {
    return realm!.query<Discount>(r'branchId == $0', [branchId]).toList();
  }

  @override
  Future<EBM?> getEbmByBranchId({required int branchId}) async {
    return realm!.query<EBM>(r'branchId == $0', [branchId]).firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    // Get a favorite
    return realm!
        .query<Favorite>(r'id == $0 AND deletedAt == nil', [favId]).firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    return realm!.query<Favorite>(
        r'favIndex == $0 AND deletedAt == nil', [favIndex]).firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) async* {
    try {
      realm!
          .query<Favorite>(r'favIndex == $0 AND deletedAt == nil', [favIndex])
          .changes
          .listen((_) async* {
            yield realm!.query<Favorite>(
                r'favIndex == $0 AND deletedAt == nil', [favIndex]).firstOrNull;
          });
    } catch (error) {
      // Handle error during query execution
      // You can emit an error signal or log the issue
      throw Exception("error streaming favorites");
    }
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) async {
    return realm!.query<Favorite>(
        r'productId == $0 AND deletedAt == nil', [prodId]).firstOrNull;
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    return realm!.query<Favorite>(r'deletedAt == nil').toList();
  }

  @override
  Product? getProduct({required int id}) {
    return realm!
        .query<Product>(r'id == $0 AND deletedAt == nil', [id]).firstOrNull;
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return realm!.query<Product>(
        r'barCode == $0 AND deletedAt == null AND branchId ==$1',
        [barCode, branchId]).firstOrNull;
  }

  /// This is dealing with search when searching the product!.
  @override
  Future<List<Product?>> getProductByName({required String name}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return realm!.query<Product>(
        r'name BEGINSWITH[c] $0 OR name CONTAINS[c] $0 OR name ENDSWITH[c] $0  AND branchId == $1',
        [name, branchId]).toList();
  }

  @override
  Future<List<Product>> getProductList({int? prodIndex}) async {
    int branchId = ProxyService.box.getBranchId()!;

    // No need for completer as Realm provides built-in async support
    final queryBuilder = realm!.query<Product>(
        r'branchId == $0  AND id =  $1 AND deletedAt == nil',
        [branchId, prodIndex]);

    return queryBuilder.toList();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) async {
    return realm!
        .query<Receipt>(r'transactionId == $0', [transactionId]).firstOrNull;
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
  Future<Setting?> getSocialSetting() {
    // TODO: implement getSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock(
      {required int branchId, required int variantId}) async {
    return realm!.query<Stock>(
        r'variantId == $0 AND branchId == $1 AND deletedAt == nil',
        [variantId, branchId]).firstOrNull;
  }

  @override
  Future<Stock?> getStockById({required int id}) async {
    return realm!.query<Stock>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Stream<double> getStockStream({int? productId, int? variantId}) async* {
    while (true) {
      double totalStock = 0.0;
      if (productId != null) {
        final query = realm!.query<Stock>(r'productId == $0', [productId]);
        totalStock = query.fold<double>(
            0.0, (sum, stock) => sum + stock.currentStock.toDouble());
      } else if (variantId != null) {
        final query = realm!.query<Stock>(r'variantId == $0', [variantId]);
        totalStock = query.fold<double>(
            0.0, (sum, stock) => sum + stock.currentStock.toDouble());
      }
      yield totalStock;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Stream<double> getStockValue({required int branchId}) async* {
    //
    while (true) {
      double totalStock = 0.0;
      final stocks = realm!.query<Stock>(r'branchId == $0', [branchId]);
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.value));
      yield totalStock;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Future<Tenant?> getTenantBYPin({required int pin}) async {
    return realm!
        .query<Tenant>(r'pin == $0 AND isDefault $1', [pin, true]).firstOrNull;
  }

  @override
  Future<Tenant?> getTenantBYUserId({required int userId}) async {
    return realm!.query<Tenant>(r'userId == $0', [userId]).firstOrNull;
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  ITransaction? getTransactionById({required int id}) {
    return realm!.query<ITransaction>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) async {
    return realm!.query<TransactionItem>(r'id == $0', [id]).firstOrNull;
  }

  @override
  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId}) {
    // Build the query string based on whether transactionId is null
    String queryString;
    List<int> parameters = [variantId]; // Initialize with variantId
    if (transactionId == null) {
      queryString = r'variantId == $0';
    } else {
      queryString = r'variantId == $0 AND transactionId == $1';
      parameters.add(transactionId); // Add transactionId only if not null
    }

    // Execute the query
    return realm!.query<TransactionItem>(queryString, parameters).firstOrNull;
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) async {
    return realm!.query<TransactionItem>(
        r'transactionId == $0', [transactionId]).toList();
  }

  @override
  Stream<List<ITransaction>> transactionStreamById(
      {required int id, required FilterType filterType}) async* {
    final controller = StreamController<List<ITransaction>>.broadcast();

    String queryString = "";
    if (filterType == FilterType.CUSTOMER) {
      queryString = r'customerId == $0';
    } else if (filterType == FilterType.TRANSACTION) {
      queryString = r'id == $0';
    }

    final query = realm!.query<ITransaction>(queryString, [id]);

    StreamSubscription<RealmResultsChanges<ITransaction>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<ITransaction>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Variant? getVariantById({required int id}) {
    return realm!.query<Variant>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    final controller = StreamController<List<Variant>>.broadcast();

    final query = realm!.query<Variant>(r'productId == $0', [productId]);

    StreamSubscription<RealmResultsChanges<Variant>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants = event.results.whereType<Variant>().toList();
        if (changedVariants.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled({required Business business}) {
    return business.tinNumber != null;
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
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType, required bool isExpense}) async {
    int branchId = ProxyService.box.getBranchId()!;

    ITransaction? existTransaction =
        await _pendingTransaction(branchId: branchId, isExpense: isExpense);

    int businessId = ProxyService.box.getBusinessId()!;
    if (existTransaction == null) {
      int id = randomNumber();
      final transaction = ITransaction(ObjectId(),
          lastTouched: DateTime.now(),
          id: id,
          supplierId: businessId,
          reference: randomNumber().toString(),
          action: AppActions.created,
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: 'Cash',
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      realm!.write(() {
        realm!.put<ITransaction>(transaction);
      });

      ProxyService.box.writeInt(key: 'currentTransactionId', value: id);
      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  ITransaction manageTransaction(
      {required String transactionType,
      required bool isExpense,
      bool? includeSubTotalCheck = false}) {
    /// check if realm is not closed
    if (realm == null) {
      throw Exception("realm is empty");
    }
    int branchId = ProxyService.box.getBranchId()!;
    ITransaction? existTransaction = _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        includeSubTotalCheck: includeSubTotalCheck!);
    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(ObjectId(),
          lastTouched: DateTime.now(),
          id: id,
          reference: randomNumber().toString(),
          action: AppActions.created,
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: 'Cash',
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      realm!.put<ITransaction>(transaction);

      ProxyService.box.writeInt(key: 'currentTransactionId', value: id);
      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    final controller = StreamController<List<ITransaction>>.broadcast();

    final query = realm!.query<ITransaction>(
        r'status == $0 AND  supplierId == $1 AND deletedAt == nil',
        [PENDING, branchId]);

    StreamSubscription<RealmResultsChanges<ITransaction>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<ITransaction>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) async {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  /// when item.active == true
  /// then this means item is on cart
  @override
  List<TransactionItem> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    int branchId = ProxyService.box.getBranchId()!;
    String queryString = "";

    queryString =
        r'transactionId == $0  && doneWithTransaction == $1  && branchId ==$2 && active == $3';

    final items = realm!.query<TransactionItem>(queryString,
        [transactionId, doneWithTransaction, branchId, active]).toList();

    return items;
  }

  /// because we want to deal with transaction that has item
  /// we just return any transaction that has TransactionItem attached
  /// this is to avoid having to deal with multiple transaction that are not complete
  /// we should first return any transaction that has item first.
  ITransaction? _pendingTransaction({
    required int branchId,
    required bool isExpense,
    bool includeSubTotalCheck = true,
  }) {
    String query =
        r'branchId == $0 AND isExpense == $1 AND status == $2 SORT(createdAt DESC)';
    List<dynamic> parameters = [branchId, isExpense, PENDING];

    if (includeSubTotalCheck) {
      query += ' AND subTotal > 0';
    }

    List<ITransaction> transactions =
        realm!.query<ITransaction>(query, parameters).toList();

    for (ITransaction transaction in transactions) {
      List<TransactionItem> items = transactionItems(
        transactionId: transaction.id!,
        doneWithTransaction: false,
        active: true,
      );

      if (items.isNotEmpty) {
        return transaction;
      }
    }

    // If no transaction with items found, return the first transaction (if any)
    return transactions.isNotEmpty ? transactions.first : null;
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    final controller = StreamController<List<Product>>.broadcast();
    int branchId = ProxyService.box.getBranchId()!;
    RealmResults<Product> query;
    if (prodIndex == null) {
      query = realm!
          .query<Product>(r'branchId == $0  AND deletedAt == nil', [branchId]);
    } else {
      query = realm!.query<Product>(
          r'branchId == $0 AND id == $1 AND deletedAt == nil',
          [branchId, prodIndex]);
    }
    StreamSubscription<RealmResultsChanges<RealmObject>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants = event.results.whereType<Product>().toList();
        if (changedVariants.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    return realm!.query<Product>(
        r'branchId == $0  AND deletedAt == nil', [branchId]).toList();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) async {
    // Define the date for recent products filtering
    final date = DateTime.now().subtract(const Duration(days: 7));

    // Fetch recent products based on branch ID and additional criteria
    List<Product> recentProducts = realm!.query<Product>(
        r'branchId == $0 && deletedAt == nil && lastTouched > $1',
        [branchId, date]).toList();

    // If no recent products are found, fetch all products for the branch
    if (recentProducts.isEmpty) {
      recentProducts = realm!.query<Product>(
          r'branchId == $0 && deletedAt == nil', [branchId]).toList();
    }

    // Filter out TEMP_PRODUCT and CUSTOM_PRODUCT and sort by lastTouched descending
    List<Product> filteredProducts = recentProducts
        .where((product) =>
            product.name != TEMP_PRODUCT && product.name != CUSTOM_PRODUCT)
        .toList()
      ..sort((a, b) => b.lastTouched!.compareTo(a.lastTouched!));

    // Limit to the last 20 items, if available
    if (filteredProducts.length > 20) {
      filteredProducts = filteredProducts.take(20).toList();
    }

    // Return the filtered and sorted list of products
    return filteredProducts;
  }

  @override
  Future<void> recordUserActivity(
      {required int userId, required String activity}) {
    // realm!.syncSession.pause();
    // TODO: implement recordUserActivity
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
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stock? stockByVariantId({required int variantId, bool nonZeroValue = false}) {
    int branchId = ProxyService.box.getBranchId()!;
    Stock? stock;
    if (nonZeroValue) {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1 && retailPrice > 0 && deletedAt ==nil',
          [variantId, branchId]).firstOrNull;
    } else {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1  && deletedAt ==nil',
          [variantId, branchId]).firstOrNull;
    }
    return stock;
  }

  @override
  Future<Stock?> stockByVariantIdFuture(
      {required int variantId, bool nonZeroValue = false}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Stock? stock;
    if (nonZeroValue) {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1 && retailPrice > 0 && deletedAt ==nil',
          [variantId, branchId]).firstOrNull;
    } else {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1  && deletedAt ==nil',
          [variantId, branchId]).firstOrNull;
    }
    return stock;
  }

  @override
  Future<double> stocks({int? productId, int? variantId}) async {
    double totalStock = 0.0;
    if (productId != null) {
      List<Stock> stocks =
          realm!.query<Stock>(r'productId == $0', [productId]).toList();
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
    } else if (variantId != null) {
      List<Stock> stocks =
          realm!.query<Stock>(r'variantId == $0', [variantId]).toList();
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
    }
    return totalStock;
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
  Future<List<Tenant>> tenants({int? businessId}) async {
    if (businessId != null) {
      return realm!.query<Tenant>(r'businessId == $0', [businessId]).toList();
    } else {
      return realm!.query<Tenant>(r'deletedAt == nil').toList();
    }
  }

  @override
  Future<List<ITransaction>> tickets() async {
    return realm!.query<ITransaction>(
        r'status == $0 && branchId == $1 && deletedAt == nil',
        [PARKED, ProxyService.box.getBranchId()!]).toList();
  }

  @override
  Stream<List<ITransaction>> ticketsStreams() {
    int branchId = ProxyService.box.getBranchId()!;

    final subject = ReplaySubject<List<ITransaction>>();

    final query = realm!.query<ITransaction>(
        r'status == $0 AND branchId == $1', [PARKED, branchId]);

    query.changes.listen((results) {
      subject.add(results.results.toList());
    });

    return subject.stream;
  }

  @override
  Future<List<TransactionItem>> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) async {
    int branchId = ProxyService.box.getBranchId()!;
    String queryString = "";

    queryString =
        r'transactionId == $0  && doneWithTransaction == $1  && branchId ==$2 && active == $3 && deletedAt = nil';

    return realm!.query<TransactionItem>(queryString,
        [transactionId, doneWithTransaction, branchId, active]).toList();
  }

  @override
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate}) {
    if (startDate == null || endDate == null) return Stream.value([]);

    final controller = StreamController<List<ITransaction>>.broadcast();

    // This is a hack as the query is failing to include data that is on the same endDate
    // so to include it I have to add 1 day to a provided endDate
    // Ref: https://stackoverflow.com/questions/74956925/querying-realm-in-flutter-using-datetime
    final query = realm!.query<ITransaction>(
      r'lastTouched >= $0 && lastTouched <= $1 && status == $2 && subTotal > 0',
      [startDate.toUtc(), endDate.add(Duration(days: 1)).toUtc(), COMPLETE],
    );

    StreamSubscription<RealmResultsChanges<ITransaction>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<ITransaction>().toList();
        // Emit the results or an empty list if no transactions found
        controller
            .add(changedTransactions.isNotEmpty ? changedTransactions : []);
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport}) {
    // if (startDate == null || endDate == null) return Stream.empty();
    final controller = StreamController<List<TransactionItem>>.broadcast();

    // talker.info("pluReport $isPluReport");
    // talker.info("startDate $startDate");
    // talker.info("startDate $endDate");

    /// Ref: https://stackoverflow.com/questions/74956925/querying-realm-in-flutter-using-datetime
    RealmResults<TransactionItem> query;

    query = realm!
        .query<TransactionItem>(r'lastTouched >= $0 && lastTouched <= $1 ', [
      startDate?.toUtc(),
      endDate?.add(Duration(days: 1)).toUtc(),
    ]);

    StreamSubscription<RealmResultsChanges<TransactionItem>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants =
            event.results.whereType<TransactionItem>().toList();
        if (changedVariants.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<List<ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    String queryString = "";
    if (isCashOut) {
      queryString = r'''status == $0
            && isExpense == true && subTotal > 0 && branchId == $1 
            SORT(createdAt DESC)
            ''';
    } else {
      queryString = r'''status == $0 && subTotal > 0  && branchId == $1
             SORT(createdAt DESC)
            ''';
    }
    final query =
        realm!.query<ITransaction>(queryString, [status ?? COMPLETE, branchId]);
    StreamController<List<ITransaction>>? controller;
    controller = StreamController<List<ITransaction>>.broadcast(onListen: () {
      final initialResults = query.toList();
      controller!.sink.add(initialResults.toList());

      query.changes.listen((results) {
        controller!.sink.add(results.results.toList());
      });
    }, onCancel: () {
      query.unsubscribe();
      controller!.close();
    });

    return controller.stream;
  }

  @override
  List<ITransaction> transactions(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      String? transactionType,
      int? branchId,
      bool isExpense = false,
      bool includePending = false}) {
    // Initialize query string
    String queryString;

    // Check if the transaction is an expense and dates are provided
    if (isExpense && startDate != null && endDate != null) {
      queryString = r'''status == $0
          && isExpense == true && subTotal > 0 && branchId == $1
          && lastTouched >= $2 && lastTouched <= $3
          SORT(createdAt DESC)
          ''';
      return realm!.query<ITransaction>(queryString, [
        status ?? COMPLETE,
        branchId,
        startDate.toUtc(),
        endDate.add(Duration(days: 1)).toUtc()
      ]).toList();
    }
    // Check if the transaction is an expense and dates are not provided
    else if (isExpense && startDate == null && endDate == null) {
      queryString = r'''status == $0
          && isExpense == true && subTotal > 0 && branchId == $1
          SORT(createdAt DESC)
          ''';
      return realm!.query<ITransaction>(
          queryString, [status ?? COMPLETE, branchId]).toList();
    }
    // For all other cases (income)
    else {
      queryString = r'''status == $0
          && isIncome == true && branchId == $1
          ''';
      return realm!.query<ITransaction>(
          queryString, [status ?? COMPLETE, branchId]).toList();
    }
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    final existingUnits =
        realm!.query<IUnit>(r'branchId == $0', [branchId]).toList();
    if (existingUnits.isNotEmpty) {
      return existingUnits;
    }
    await addUnits(units: mockUnits);
    return realm!.query<IUnit>(
        r'branchId ==$0 AND deletedAt == nil', [branchId]).toList();
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError();
  }

  /// Please do not place any realm update here since realm require that when we modify the property
  /// of a model to do it within write transaction so the change take imediate effect and it was natural for our case
  /// that we modify the object and pass in the final object to be updated here later and that will not work with realm
  /// therefore we do the update within write function where the actual update is taking place to avoid crazy error or illusion
  @override
  Future<int> updateNonRealm<T>({required T data}) async {
    /// update user activity
    int userId = ProxyService.box.getUserId() ?? 0;
    if (userId == 0) return 0;
    if (data is Business) {
      final business = data;
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/business/${business.id}"),
          body: jsonEncode(business.toEJson()));
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the business");
      }
    } else if (data is Branch) {
      final branch = data;
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/branch/${branch.id}"),
          body: jsonEncode(branch.toEJson()));
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the branch");
      }
    } else if (data is User) {
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/user"),
          body: jsonEncode(data.toEJson()));
      return response.statusCode;
    } else if (data is Tenant) {
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/tenant/${data.id}"),
          body: jsonEncode(data.toEJson()));
      if (response.statusCode == 200) {
        realm!.write(() {
          realm!.add<Tenant>(data);
        });
      }
      return response.statusCode;
    }

    return 0;
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable({required String name}) async {
    final response =
        await flipperHttpClient.get(Uri.parse("$apihub/search?name=$name"));
    return response.statusCode;
  }

  @override
  Variant? variant({int? variantId, String? name}) {
    if (variantId != null) {
      return realm!.query<Variant>(r'id == $0', [variantId]).firstOrNull;
    }
    if (name != null) {
      return realm!.query<Variant>(r'name == $0', [name]).firstOrNull;
    }
    return null;
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, int? productId}) async {
    List<Variant> variants = [];
    if (productId != null) {
      variants = realm!.query<Variant>(
          r'productId == $0 && branchId == $1 && retailPrice >0',
          [productId, branchId]).toList();
    } else {
      variants = realm!.query<Variant>(
          r'branchId == $0 && retailPrice >0', [branchId]).toList();
    }
    return variants;
  }

  /// because both non-synced and synced should be in one dir
  /// I avoided assigning businessId or branchId to the directory
  /// because it assumed that realm will upload data if they exist and they are not synced
  @override
  Future<String> dbPath({required String path, int? folder}) async {
    try {
      Directory appSupportDirectory;

      // Determine the appropriate directory based on the platform
      if (Platform.isWindows) {
        appSupportDirectory = await getApplicationSupportDirectory();
      } else {
        appSupportDirectory = await getApplicationDocumentsDirectory();
      }

      // Construct the specific directory path
      /// the 1 appended is incremented everytime there is a breaking change on a client.
      final realmDirectory =
          p.join(appSupportDirectory.path, '${folder ?? ""}2');

      // Create the directory if it doesn't exist
      final directory = Directory(realmDirectory);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Construct the full path to the database file
      final String fileName = '$path.realm';
      return p.join(realmDirectory, fileName);
    } catch (e) {
      // Handle any exceptions that might occur
      print('Error creating db path: $e');
      rethrow;
    }
  }

  /// when opening db we carefully fail gracefuly when especially on startup we use in memory db
  /// then when user login the real db is used
  /// it is very important to avoid issue where we are saving in memory thinking that we using synced db hence why we call init on startupview model
  /// to re-configure the db now for this time not using the in-memory db.
  ///

  @override
  Future<RealmApiInterface> instance() async {
    return this;
  }

  @override
  Future<RealmApiInterface> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      String? encryptionKey,
      int? businessId,
      int? branchId,
      int? userId}) async {
    _setApiEndpoints();

    realm?.close();

    /// do not provide fallback if the user is not authenticated.
    if (useFallBack) {
      realm?.close();
      _configureInMemory();
      return this;
    }

    try {
      final app = App(AppConfiguration(AppSecrets.appId,
          baseUrl: Uri.parse("https://services.cloud.mongodb.com")));

      /// When this login does not execute or take too long user will not be able
      /// to proceed and use the app,!
      /// https://github.com/realm/realm-dart/issues/1205 support using firebase credentials
      /// this will help in avoiding sharing api key!
      /// https://github.com/realm/realm-dart/issues/1205#issuecomment-1465778841
      User user = app.currentUser ??
          await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));
      if (useInMemoryDb || encryptionKey == null || encryptionKey.isEmpty) {
        talker.error("Using in Memory db");
        realm?.close();
        _configureInMemory();
        return this;
      } else {
        if (businessId == null) {
          talker.error("There is no business found");
          // throw Exception("here is no business found");
          realm?.close();
          _configureInMemory();
          return this;
        }
        realm?.close();
        String path = await dbPath(path: 'synced', folder: businessId);
        await _configurePersistent(
          user: user,
          path: path,
          businessId: businessId,
          branchId: branchId!,
          userId: userId!,
          app: app,
        );
        return this;
      }
    } catch (e, s) {
      /// after a lof of thinking a fallback should use in memory because
      /// we can not think of Ream(config) will be totally different from Realm.open()
      /// hence I can not provide different encryption key on either
      talker.error(s);
      logOut();
      rethrow;
    }
  }

  void _configureInMemory() {
    Configuration config = Configuration.inMemory(realmModels);
    realm = Realm(config);
    talker.info("Opened in-memory realm.");
  }

  Future<void> _configurePersistent(
      {required User user,
      required String path,
      required int businessId,
      required int branchId,
      required int userId,
      required App app}) async {
    CancellationToken token = CancellationToken();
    Future<void>.delayed(
        const Duration(seconds: 30),
        () => token.cancel(CancelledException(
            cancellationReason: "Realm took too long to open")));
    talker.warning("opening persistent");
    // Sentry.captureMessage("opening persistent");
    Configuration? config = await _createPersistentConfig(user, path);
    if (config == null) {
      throw Exception();
    }
    realm = await _openRealm(config: config, user: user, app: app);

    if (await ProxyService.status.isInternetAvailable()) {
      await updateSubscription(
          branchId: branchId, businessId: businessId, userId: userId);
      await realm!.syncSession.waitForDownload();
      await realm!.subscriptions.waitForSynchronization(token);
    }
  }

  ///https://www.mongodb.com/docs/atlas/device-sdks/sdk/flutter/sync/handle-sync-errors/import 'dart:io';
  Future<Configuration?> _createPersistentConfig(User user, String path) async {
    try {
      talker.warning("using key: ${ProxyService.box.encryptionKey()}");
      return Configuration.flexibleSync(
        user,
        realmModels,
        encryptionKey: ProxyService.box.encryptionKey().toIntList(),
        path: path,
        shouldCompactCallback: (totalSize, usedSize) {
          const tenMB = 10 * 1048576;
          return (totalSize > tenMB) &&
              (usedSize.toDouble() / totalSize.toDouble()) < 0.5;
        },
        syncErrorHandler: (syncError) {
          if (syncError is CompensatingWriteError) {
            handleCompensatingWrite(syncError);
          }
        },
        clientResetHandler: RecoverOrDiscardUnsyncedChangesHandler(
          onBeforeReset: (realm) {
            print(
                'A client reset is about to occur. The app may freeze momentarily.');
          },
          onAfterRecovery: (before, after) {
            print('Automatic client reset recovery completed successfully.');
          },
          onAfterDiscard: (before, after) {
            talker.error(
                'Automatic client reset recovery failed. Local changes have been discarded.');
          },
          onManualResetFallback: (clientResetError) async {
            print('Automatic client reset failed. Manual reset is required.');

            await Future.delayed(Duration(seconds: 10));

            // 1. Close the realm
            realm!.close();

            // 2. Delete the realm file
            try {
              // clientResetError.resetRealm();
              File realmFile = File(realm!.config.path);
              if (await realmFile.exists()) {
                await realmFile.delete();
                print('Realm file deleted successfully.');
              }
              await logOut();
            } catch (e) {
              // print('Error deleting realm file: $e');
            }

            // 3. Restart the app
            print('Restarting the app...');
            // exit(0);
            await logOut();

            //the app re-initialize here
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Realm> _openRealm(
      {required Configuration config,
      required User user,
      required App app}) async {
    CancellationToken token = CancellationToken();
    Future<void>.delayed(
        const Duration(seconds: 30),
        () => token.cancel(CancelledException(
            cancellationReason: "Realm took too long to open")));

    try {
      if (await ProxyService.status.isInternetAvailable()) {
        talker.info("Opened realm with internet access.");
        return await Realm.open(config, cancellationToken: token,
            onProgressCallback: (syncProgress) {
          if (syncProgress.progressEstimate == 1.0) {
            talker.info('All bytes transferred!');
          }
        });
        // return Realm(config);
      } else {
        talker.info("Opened realm with no internet access.");
        return Realm(config);
      }
    } on CancelledException catch (_) {
      return Realm(config);
    } catch (e, s) {
      talker.error(s);
      close();
      throw e;
      // return Realm(config);
    }
  }

  void _setApiEndpoints() {
    if (foundation.kDebugMode) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }
  }

  Future<void> updateSubscription(
      {int? branchId, int? businessId, int? userId}) async {
    for (Subscription sub in realm!.subscriptions) {
      talker.warning(sub.name);
    }

    if (realm == null ||
        businessId == null ||
        branchId == null ||
        userId == null) return;
    //https://www.mongodb.com/docs/realm/sdk/flutter/sync/manage-sync-subscriptions/
    final transactionItem =
        realm!.query<TransactionItem>(r'branchId == $0', [branchId]);
    final product = realm!.query<Product>(r'branchId == $0', [branchId]);
    final variant = realm!.query<Variant>(r'branchId == $0', [branchId]);
    final stock = realm!.query<Stock>(r'branchId == $0', [branchId]);
    final unit = realm!.query<IUnit>(r'branchId == $0', [branchId]);
    final counter = realm!.query<Counter>(r'branchId == $0', [branchId]);

    final customer = realm!.query<Customer>(r'branchId == $0', [branchId]);
    final category = realm!.query<Category>(r'branchId == $0', [branchId]);
    final colors = realm!.all<PColor>();
    final devices = realm!.query<Device>(r'branchId == $0', [branchId]);

    final transaction =
        realm!.query<ITransaction>(r'branchId == $0', [branchId]);

    final conversations =
        realm!.query<Conversation>(r'businessId == $0', [businessId]);

    final ebms = realm!.query<EBM>(r'businessId == $0', [businessId]);

    final receipts = realm!.query<Receipt>(r'branchId == $0', [branchId]);
    final units = realm!.query<IUnit>(r'branchId == $0', [branchId]);
    // final permission = realm!.query<LPermission>(r'userId == $0', [userId]);

    final pin = realm!.query<Pin>(
        r'userId == $0', [ProxyService.box.getUserId()?.toString()]);

    // fake subscription as I normally do not these model synced across devices but I don't know how I can pause one model
    final token = realm!.query<Token>(r'businessId == $0', [businessId]);
    final tenant = realm!.query<Tenant>(r'businessId == $0', [businessId]);
    final favorites = realm!.query<Favorite>(r'branchId == $0', [branchId]);
    final drawers = realm!.query<Drawers>(r'cashierId == $0', [userId]);
    final configs = realm!.query<Configurations>(r'branchId == $0', [branchId]);
    final assets = realm!.query<Assets>(r'branchId == $0', [branchId]);
    final composites = realm!.query<Composite>(r'branchId == $0', [branchId]);
    final skus = realm!.query<SKU>(r'branchId == $0', [branchId]);
    final report = realm!.query<Report>(r'branchId == $0', [branchId]);
    final computed = realm!.query<Computed>(r'branchId == $0', [branchId]);
    final access = realm!.query<Access>(r'businessId == $0', [businessId]);

    /// https://www.mongodb.com/docs/atlas/device-sdks/sdk/flutter/sync/manage-sync-subscriptions/
    /// First unsubscribe
    // drawers.unsubscribe();
    // token.unsubscribe();
    // tenant.unsubscribe();
    // permission.unsubscribe();
    // pin.unsubscribe();
    // units.unsubscribe();
    // receipts.unsubscribe();
    // favorites.unsubscribe();
    // ebms.unsubscribe();
    // devices.unsubscribe();
    // conversations.unsubscribe();
    // colors.unsubscribe();
    // category.unsubscribe();
    // customer.unsubscribe();
    // receipts.unsubscribe();
    // receipts.unsubscribe();
    // devices.unsubscribe();
    // transaction.unsubscribe();
    // End of unsubscribing

    realm!.subscriptions.update((MutableSubscriptionSet mutableSubscriptions) {
      mutableSubscriptions.add(access, name: "access", update: true);
      mutableSubscriptions.add(composites, name: "composites", update: true);
      mutableSubscriptions.add(computed, name: "computed", update: true);
      mutableSubscriptions.add(drawers, name: "drawers", update: true);
      mutableSubscriptions.add(token, name: "token", update: true);
      mutableSubscriptions.add(assets, name: "assets", update: true);
      mutableSubscriptions.add(skus, name: "skus", update: true);
      mutableSubscriptions.add(report, name: "report", update: true);

      mutableSubscriptions.add(tenant,
          name: "tenant-${businessId}", update: true);
      // mutableSubscriptions.add(permission,
      //     name: "permission-${userId}", update: true);
      mutableSubscriptions.add(pin, name: "pin-${businessId}", update: true);
      mutableSubscriptions.add(units,
          name: "units-${businessId}", update: true);
      mutableSubscriptions.add(receipts,
          name: "receipts-${businessId}", update: true);
      mutableSubscriptions.add(favorites,
          name: "favorites-${branchId}", update: true);
      mutableSubscriptions.add(ebms, name: "ebms-${businessId}", update: true);
      mutableSubscriptions.add(devices,
          name: "devices-${businessId}", update: true);
      mutableSubscriptions.add(conversations,
          name: "conversations-${businessId}", update: true);
      mutableSubscriptions.add(colors,
          name: "colors-${businessId}", update: true);
      mutableSubscriptions.add(category,
          name: "category-${businessId}", update: true);
      mutableSubscriptions.add(customer,
          name: "iCustomer-${branchId}", update: true);
      mutableSubscriptions.add(product,
          name: "iProduct-${branchId}", update: true);
      mutableSubscriptions.add(counter,
          name: "iCounter-${branchId}", update: true);
      mutableSubscriptions.add(variant,
          name: "iVariant-${branchId}", update: true);
      mutableSubscriptions.add(stock, name: "iStock-${branchId}", update: true);
      mutableSubscriptions.add(unit, name: "iUnit-${branchId}", update: true);
      mutableSubscriptions.add(transaction,
          name: "transaction-${branchId}", update: true);
      mutableSubscriptions.add(transactionItem,
          name: "transactionItem-${branchId}", update: true);

      mutableSubscriptions.add(configs, name: "configs", update: true);
    });
  }

  @override
  Future<int> addVariant({required List<Variant> variations}) async {
    final branchId = ProxyService.box.getBranchId()!;
    try {
      for (final variation in variations) {
        await _processVariant(branchId, variation);
      }
      return 200;
    } catch (e) {
      print('Failed to add variants: $e');
      rethrow;
    }
  }

  Future<void> _processVariant(int branchId, Variant variation) async {
    try {
      int stockId = randomNumber();
      Variant? variant = realm!.query<Variant>(
          r'id == $0 && branchId == $1 && deletedAt == nil',
          [variation.id, branchId]).firstOrNull;

      if (variant != null) {
        Stock? stock = realm!.query<Stock>(
            r'id == $0 && branchId == $1 && deletedAt == nil',
            [stockId, branchId]).firstOrNull;

        if (stock == null) {
          final newStock = Stock(ObjectId(),
              id: stockId,
              lastTouched: DateTime.now(),
              branchId: branchId,
              variantId: variation.id!,
              action: AppActions.created,
              retailPrice: variation.retailPrice,
              supplyPrice: variation.supplyPrice,
              currentStock: variation.qty,
              rsdQty: variation.qty,
              value: (variation.qty * (variation.retailPrice)).toDouble(),
              productId: variation.productId,
              active: false);
          await realm!.putAsync<Stock>(newStock);
        }

        stock!.currentStock = stock.currentStock + variation.qty;
        stock.rsdQty = stock.currentStock + variation.qty;
        stock.action = AppActions.updated;
        stock.lastTouched = DateTime.now().toLocal();
        stock.value = (variation.qty * (variation.retailPrice)).toDouble();
        await realm!.putAsync<Stock>(stock);

        variant.qty = variation.qty;
        variant.retailPrice = variation.retailPrice;
        variant.supplyPrice = variation.supplyPrice;
        variant.action = AppActions.updated;
        variant.lastTouched = DateTime.now().toLocal();
        await realm!.putAsync<Variant>(variant);
      } else {
        int stockId = randomNumber();

        talker.info("Saving variant when scanning..... [1]");

        await realm!.putAsync<Variant>(variation);

        final newStock = Stock(ObjectId(),
            id: stockId,
            lastTouched: DateTime.now(),
            branchId: branchId,
            variantId: variation.id,
            action: AppActions.created,
            retailPrice: variation.retailPrice,
            supplyPrice: variation.supplyPrice,
            currentStock: variation.qty,
            value: (variation.qty * (variation.retailPrice)).toDouble(),
            productId: variation.productId)
          ..active = true;

        realm!.putAsync<Stock>(newStock);
      }
    } catch (e, s) {
      talker.error(s);
    }
  }

  @override
  void createVariant(
      {required String barCode,
      required String sku,
      required int productId,
      required double retailPrice,
      required double supplierPrice,
      required String color,
      required double qty,
      required int itemSeq,
      required int tinNumber,
      required String name}) {
    Variant variant = _createRegularVariant(
        ProxyService.box.getBranchId()!, tinNumber,
        qty: qty,
        supplierPrice: supplierPrice,
        retailPrice: retailPrice,
        itemSeq: itemSeq,
        name: name,
        sku: sku,
        ebmSynced: false,
        productId: productId);
    realm!.write(() {
      realm!.add<Variant>(variant);
    });
  }

  Variant _createRegularVariant(int branchId, int? tinNumber,
      {required double qty,
      required double supplierPrice,
      required double retailPrice,
      required int itemSeq,
      required bool ebmSynced,
      Product? product,
      required int productId,
      required String name,
      required String sku}) {
    final int variantId = randomNumber();
    final number = randomNumber().toString().substring(0, 5);
    String itemPrefix = "FLIPPER-";
    String clip = itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);
    return Variant(ObjectId(),
        lastTouched: DateTime.now(),
        name: product?.name ?? name,
        sku: sku,
        action: 'create',
        productId: product?.id ?? productId,
        color: product?.color,
        unit: 'Per Item',
        productName: product?.name ?? name,
        branchId: branchId,
        supplyPrice: supplierPrice,
        retailPrice: retailPrice,
        id: variantId,
        isTaxExempted: false,
        bhfId: ProxyService.box.bhfId() ?? '00',
        itemStdNm: "Regular",
        addInfo: "A",
        pkg: "1",
        splyAmt: supplierPrice,
        itemClsCd: "5020230602",
        itemCd: clip,
        modrNm: number,
        modrId: number,
        pkgUnitCd: "BJ",
        regrId: randomNumber().toString().substring(0, 5),
        rsdQty: qty,
        itemTyCd: "2", // this is a finished product
        /// available type for itemTyCd are 1 for raw material and 3 for service
        /// is insurance applicable default is not applicable
        isrcAplcbYn: "N",
        useYn: "N",
        itemSeq: itemSeq,
        itemNm: product?.name ?? name,
        taxPercentage: 18.0,
        tin: tinNumber,
        bcd: product?.name ?? name,

        /// country of origin for this item we default until we support something different
        /// and this will happen when we do import.
        orgnNatCd: "RW",

        /// registration name
        regrNm: product?.name ?? name,

        /// taxation type code
        taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
        // default unit price
        dftPrc: retailPrice,
        prc: retailPrice,

        // NOTE: I believe bellow item are required when saving purchase
        ///but I wonder how to get them when saving an item.
        spplrItemCd: "",
        spplrItemClsCd: "",
        spplrItemNm: product?.name ?? name,

        /// Packaging Unit
        qtyUnitCd: "U", // see 4.6 in doc
        ebmSynced: ebmSynced);
  }

  _findProductByBusinessId({required String name, required int businessId}) {
    return realm!.query<Product>(
        r'businessId == $0 AND name == $1', [businessId, name]).firstOrNull;
  }

  Future<Variant?> _addMissingVariant(
      Variant? variant, Product? product, int branchId, int tinNumber) async {
    final number = randomNumber().toString().substring(0, 5);

    try {
      if (variant == null) {
        int variantId = randomNumber();

        variant = Variant(ObjectId(),
            id: variantId,
            lastTouched: DateTime.now(),
            name: product!.name,
            color: product.color,
            sku: 'sku',
            action: 'create',
            productId: product.id!,
            unit: 'Per Item',
            productName: product.name,
            branchId: branchId,
            supplyPrice: 0.0,
            retailPrice: 0.0,
            itemNm: product.name,
            bhfId: ProxyService.box.bhfId() ?? '00',
            isTaxExempted: false,
            // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
            itemClsCd: "5020230602",
            itemCd: randomNumber().toString().substring(0, 5),
            modrNm: number,
            modrId: number,
            pkgUnitCd: "BJ",
            regrId: randomNumber().toString().substring(0, 5),
            rsdQty: 1,
            itemTyCd: "2", // this is a finished product
            /// available type for itemTyCd are 1 for raw material and 3 for service
            /// is insurance applicable default is not applicable
            isrcAplcbYn: "N",
            useYn: "N",
            itemSeq: 1,
            itemStdNm: product.name,
            taxPercentage: 18.0,
            tin: tinNumber,
            bcd: CUSTOM_PRODUCT,

            /// country of origin for this item we default until we support something different
            /// and this will happen when we do import.
            orgnNatCd: "RW",

            /// registration name
            regrNm: CUSTOM_PRODUCT,

            /// taxation type code
            taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
            // default unit price
            dftPrc: 0,

            // NOTE: I believe bellow item are required when saving purchase
            ///but I wonder how to get them when saving an item.
            spplrItemCd: randomNumber().toString().substring(0, 5),
            spplrItemClsCd: randomNumber().toString().substring(0, 5),
            spplrItemNm: CUSTOM_PRODUCT,
            qtyUnitCd: "U");

        Stock stock = Stock(ObjectId(),
            lastTouched: DateTime.now(),
            id: randomNumber(),
            action: 'create',
            branchId: branchId,
            variantId: variantId,
            currentStock: 0.0,
            productId: product.id!)
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..currentStock = 0.0
          ..branchId = branchId
          ..variantId = variantId
          ..supplyPrice = 0.0
          ..retailPrice = 0.0
          ..lowStock = 10.0 // default static
          ..canTrackingStock = true
          ..showLowStockAlert = true
          ..active = false
          ..productId = product.id!
          ..rsdQty = 0.0;

        realm!.put<Variant>(variant);

        realm!.put<Stock>(stock);

        return realm!.query<Variant>(r'id == $0 ', [variantId]).firstOrNull;
      }
    } catch (e, s) {
      // Handle error during write operation
      talker.error(e);
      talker.error(s);
      throw Exception(e);
    }
    return variant;
  }

  @override
  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError();
  }

  @override
  Future<LPermission?> permission({required int userId}) async {
    return realm!.query<LPermission>(r'userId == $0 ', [userId]).firstOrNull;
  }

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": "1", "typeName": "Flipper Retailer"}
      // {"id": "2", "typeName": "Flipper Connecta"},`
    ];
    Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Future<IPin?> getPin({required String pin}) async {
    final Uri uri = Uri.parse("$apihub/v2/api/pin/$pin");

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        return IPin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw PinError(term: "Not found");
      } else {
        throw PinError(term: "Not found");
      }
    } catch (error) {
      talker.warning(error);
      PinError(term: "Not found");
    }
    throw UnknownError(term: "Pin might be invalid!");
  }

  @override
  bool isRealmClosed() {
    return realm?.isClosed ?? true;
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) async* {
    final controller = StreamController<List<TransactionItem>>.broadcast();

    final query = realm!.query<TransactionItem>(
        r'transactionId == $0 AND doneWithTransaction ==$1 AND active == $2 AND deletedAt == nil',
        [transactionId, doneWithTransaction, active]);

    StreamSubscription<RealmResultsChanges<TransactionItem>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<TransactionItem>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Stream<double> soldStockValue({required branchId}) async* {
    // Get the list of TransactionItem objects for the given branchId

    /// first check in Computed model if we have already calculated the value
    final List<Computed> computeds =
        realm!.query<Computed>(r'branchId == $0', [branchId]).toList();

    if (computeds.isNotEmpty) {
      // Find the computed entry with the highest totalStockSoldValue
      final computed = computeds.reduce((curr, next) =>
          (next.totalStockSoldValue ?? 0) > (curr.totalStockSoldValue ?? 0)
              ? next
              : curr);

      yield computed.totalStockSoldValue?.toPrecision(2) ?? 0;
      return;
    }
    final List<TransactionItem> transactions =
        realm!.query<TransactionItem>(r'branchId == $0', [branchId]).toList();

    // Calculate the total sold value
    double totalSoldValue =
        transactions.fold(0, (sum, transaction) => sum + transaction.totAmt);

    // Yield the total sold value
    yield totalSoldValue;
  }

  Stream<double> stockValue({required branchId}) async* {
    // Get the list of Stock objects for the given branchId
    /// first check in Computed model if we have already calculated the value
    final List<Computed> computeds =
        realm!.query<Computed>(r'branchId == $0', [branchId]).toList();

    if (computeds.isNotEmpty) {
      // Find the computed entry with the highest totalStockValue
      final computed = computeds.reduce((curr, next) =>
          (next.totalStockValue ?? 0) > (curr.totalStockValue ?? 0)
              ? next
              : curr);

      yield computed.totalStockValue?.toPrecision(2) ?? 0;
      return;
    }

    final List<Stock> stocks = realm!.query<Stock>(
        r'currentStock > $0 AND branchId == $1', [0, branchId]).toList();

    // Calculate the total stock value
    double totalStockValue = stocks.fold(
        0, (sum, stock) => sum + (stock.currentStock * stock.retailPrice));

    // Yield the total stock value
    yield totalStockValue;
  }

  void handleCompensatingWrite(CompensatingWriteError compensatingWriteError) {
    final writeReason = compensatingWriteError.compensatingWrites!.first;
    print("Error message: " + writeReason.reason);

    // ... handle compensating write error as needed.
  }

  @override
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true}) async {
    try {
      if (model is Variant) {
        realm!.write(() {
          model.ebmSynced = updated;
        });
      }
      if (model is Stock) {
        realm!.write(() {
          model.ebmSynced = updated;
        });
      }
    } catch (e) {}
  }

  @override
  Stream<List<Category>> categoryStream() async* {
    final controller = StreamController<List<Category>>.broadcast();
    final branchId = ProxyService.box.getBranchId()!;

    final query = realm!.query<Category>(r'branchId == $0 ', [branchId]);

    StreamSubscription<RealmResultsChanges<Category>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<Category>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Configurations getByTaxType({required String taxtype}) {
    Configurations result;
    double taxPercentage;

    Configurations? config =
        realm!.query<Configurations>(r'taxType == $0', [taxtype]).firstOrNull;

    if (config != null) return config;

    if (taxtype == "B") {
      taxPercentage = 18.0;
    } else {
      taxPercentage = 0.0;
    }

    result = Configurations(
      ObjectId(),
      taxPercentage: taxPercentage,
      taxType: taxtype,
      id: randomNumber(),
      branchId: ProxyService.box.getBranchId(),
      businessId: ProxyService.box.getBusinessId(),
    );
    realm!.write(() => realm!.add(result));
    return result;
  }

  @override
  Future<RwApiResponse> selectImportItems(
      {required int tin, required String bhfId, required String lastReqDt}) {
    return ProxyService.tax.selectImportItems(
      tin: tin,
      bhfId: bhfId,
      lastReqDt: lastReqDt,
      URI: ProxyService.box.getServerUrl()!,
    );
  }

  @override
  Future<bool> logOut() async {
    if (ProxyService.box.getUserId() != null &&
        ProxyService.box.getBusinessId() != null) {
      ProxyService.event.publish(loginDetails: {
        'channel': "${ProxyService.box.getUserId()!}-logout",
        'userId': ProxyService.box.getUserId()!,
        'businessId': ProxyService.box.getBusinessId()!,
        'branchId': ProxyService.box.getBranchId()!,
        'phone': ProxyService.box.getUserPhone(),
        'defaultApp': ProxyService.box.getDefaultApp(),
        'deviceName': Platform.operatingSystem,
        'uid':
            (await firebase.FirebaseAuth.instance.currentUser?.getIdToken()) ??
                "",
        'deviceVersion': Platform.operatingSystemVersion,
        'linkingCode': randomNumber().toString()
      });
    }
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'getIsTokenRegistered');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    ProxyService.box.remove(key: 'defaultApp');
    ProxyService.box.remove(key: 'authComplete');
    // but for shared preference we can just clear them all
    /// We do not clear all variable, this is because even on logout
    /// a user log in back and there is values such as tinNumber,bhfId,URI that we will still need to re-use
    /// therefore why the bellow line is commented out.

    await firebase.FirebaseAuth.instance.signOut();

    /// refreshing the user token will invalidate any session
    await firebase.FirebaseAuth.instance.currentUser?.getIdToken(true);

    await amplifyLogout();

    /// calling close on logout inroduced error where another attempt to login will fail since
    /// the instance of realm is instantiated at app start level.
    // resetDependencies(dispose: true);
    /// wait to sync data for this eod
    // await ProxyService.realm.realm!.syncSession.waitForUpload();
    close();
    ProxyService.realm.realm = null;
    return Future.value(true);
  }
  //// drawers

  /// because a drawer is open per the user logged in
  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    return realm?.query<Drawers>(
            r'cashierId == $0 AND open == $1 && branchId == $2',
            [cashierId, true, branchId]).firstOrNull !=
        null;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    return realm!.query<Drawers>(
        r'open == true AND cashierId == $0', [cashierId]).firstOrNull;
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    realm!.write(() {
      realm!.add<Drawers>(drawer);
    });
    return realm!.query<Drawers>(r'id == $0 ', [drawer.id]).firstOrNull;
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) async {
    try {
      final result = await amplify.Amplify.Auth.fetchAuthSession();
      if (!result.isSignedIn) {
        final signInResult = await amplify.Amplify.Auth.signIn(
          username: identifier,
          password: identifier,
        );
        if (signInResult.isSignedIn) {
          talker.warning('User logged in successfully');
        } else {
          talker.warning('Login not complete. Additional steps required.');
        }
      }

      /// TODO: once I enable for a user to auth using his creds maybe I will enable this
      /// but we have one user we keep using for auth uploads
      // final Map<cognito.AuthUserAttributeKey, String> userAttributes = {
      //   if (identifier.contains('@'))
      //     cognito.AuthUserAttributeKey.email: identifier,
      //   if (!identifier.contains('@')) ...{
      //     cognito.AuthUserAttributeKey.phoneNumber: identifier,
      //     // Provide a default email to satisfy the schema requirement
      //     cognito.AuthUserAttributeKey.email: 'yegobox@gmail.com',
      //   }
      // };

      // final signUpResult = await amplify.Amplify.Auth.signUp(
      //   username: identifier,
      //   password:
      //       identifier, // Using the identifier as the password for simplicity
      //   options: cognito.SignUpOptions(
      //     userAttributes: userAttributes,
      //   ),
      // );

      // if (signUpResult.isSignUpComplete) {
      //   talker.warning('User signed up successfully!');
      // } else {
      //   talker.warning('Sign up not complete. Additional steps required.');
      // }
    } on cognito.AuthException catch (e) {
      talker.error('Unexpected error: $e');
      // rethrow;
    } catch (e) {
      talker.error('Unexpected error: $e');
      // rethrow;
    }
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    await syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");
    int branchId = ProxyService.box.getBranchId()!;
    final applicationSupportDirectory = await getApplicationSupportDirectory();

    if (assetName != null) {
      return _downloadAsset(
          branchId, assetName, applicationSupportDirectory.path, subPath!);
    }

    List<Assets> assets =
        realm!.query<Assets>(r'branchId == $0', [branchId]).toList();

    StreamController<double> progressController = StreamController<double>();

    for (Assets asset in assets) {
      if (asset.assetName != null) {
        // Get the download stream
        Stream<double> downloadStream = await _downloadAsset(branchId,
            asset.assetName!, applicationSupportDirectory.path, subPath!);

        // Listen to the download stream and add its events to the main controller
        downloadStream.listen((progress) {
          print('Download progress for ${asset.assetName}: $progress');
          progressController.add(progress);
        }, onError: (error) {
          // Handle errors in the download stream
          talker
              .error('Error in download stream for ${asset.assetName}: $error');
          progressController.addError(error);
        });
      } else {
        talker.warning('Asset name is null for asset: ${asset.id}');
      }
    }

    // Close the stream controller when all downloads are finished
    Future.wait(assets.map((asset) => asset.assetName != null
        ? _downloadAsset(branchId, asset.assetName!,
            applicationSupportDirectory.path, subPath!)
        : Future.value(Stream.empty()))).then((_) {
      progressController.close();
    }).catchError((error) {
      talker.error('Error in downloading assets: $error');
      progressController.close();
    });

    return progressController.stream;
  }

  Future<Stream<double>> _downloadAsset(int branchId, String assetName,
      String directoryPath, String subPath) async {
    final filePath = '$directoryPath/$assetName';
    final file = File(filePath);

    if (await file.exists()) {
      talker.info('File already exists: ${file.path}');
      return Stream.value(100.0); // Return a stream indicating 100% completion
    }

    final storagePath = amplify.StoragePath.fromString(
        'public/${subPath}-$branchId/$assetName');

    try {
      // Create a stream controller to manage the progress
      final progressController = StreamController<double>();

      // Start the download process
      final operation = amplify.Amplify.Storage.downloadFile(
        path: storagePath,
        localFile: amplify.AWSFile.fromPath(filePath),
        onProgress: (progress) {
          // Calculate the progress percentage
          final percentageCompleted =
              (progress.fractionCompleted * 100).toInt();
          // Add the progress to the stream
          progressController.sink.add(percentageCompleted.toDouble());
        },
      );

      // Listen for the download completion
      operation.result.then((_) {
        progressController.close();
      }).catchError((error) async {
        String path = 'public/${subPath}-$branchId/$assetName';
        try {
          /// first delete asset from realm
          Assets? asset = getAsset(assetName: assetName);
          if (asset != null) {
            ProxyService.realm.realm!.write(() {
              ProxyService.realm.realm!.delete(asset);
            });
          }
          await amplify.Amplify.Storage.remove(
            path: storagePath,
            // options: const amplify.StorageRemoveOptions()
          );
          talker.info('Asset deleted from S3 after download error: $path');
        } catch (deleteError) {
          talker.error(
              'Failed to delete asset from S3: $path - ${deleteError.toString()}');
        }
        progressController.addError(error);
        progressController.close();
      });

      return progressController.stream;
    } catch (e) {
      // String path = 'public/${subPath}-$branchId/$assetName';
      talker.error('Error downloading file: $e');
      rethrow;
    }
  }

  @override
  Future<bool> removeS3File({required String fileName}) async {
    await syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");
    int branchId = ProxyService.box.getBranchId()!;
    try {
      final result = await amplify.Amplify.Storage
          .remove(
            path: amplify.StoragePath.fromString(
                'public/branch-$branchId/$fileName'),
          )
          .result;
      talker.warning('Removed file: ${result.removedItem.path}');
      return true; // Return true if the file is successfully removed
    } on amplify.StorageException catch (e) {
      talker.warning(e.message);
      return false; // Return false if an exception occurs during the removal process
    }
  }

  @override
  Assets? getAsset({required String assetName}) {
    return realm!.query<Assets>(r'assetName == $0', [assetName]).firstOrNull;
  }

  @override
  Future<void> amplifyLogout() async {
    try {
      amplify.Amplify.Auth.signOut();
    } catch (e) {}
  }

  @override
  List<Product> getProducts({String? key}) {
    final product = realm!.query<Product>(r'name CONTAINS $0', [key]).toList();
    return product;
  }

  @override
  List<Variant> getVariants({String? key}) {
    final variant =
        realm!.query<Variant>(r'productName CONTAINS $0', [key]).toList();
    return variant;
  }

  @override
  void saveComposite({required Composite composite}) {
    realm!.write(() {
      realm!.add<Composite>(composite);
    });
  }

  // Function to create a new SKU
  SKU _createNewSku() {
    return SKU(
      ObjectId(),
      id: randomNumber(),
      sku: 1000,
      branchId: ProxyService.box.getBranchId(),
      businessId: ProxyService.box.getBusinessId(),
      consumed: false,
    );
  }

  SKU? _getSku({required int branchId}) {
    if (realm == null) {
      throw Exception('Realm is null!');
    }

    // Check for existing non-consumed SKU
    SKU? existingSku = realm!.query<SKU>(
        r'branchId == $0 AND consumed == false', [branchId]).firstOrNull;

    try {
      if (existingSku == null) {
        realm!.write(() {
          existingSku = _createNewSku();
          realm!.add<SKU>(existingSku!);
        });
      }
    } catch (e) {
      talker.error(e);
    }

    return existingSku;
  }

  @override
  Stream<SKU?> sku({required int branchId}) async* {
    if (realm == null) {
      throw Exception('Realm is null!');
    }

    // Check for existing non-consumed SKU
    SKU? existingSku = realm!.query<SKU>(
        r'branchId == $0 AND consumed == false', [branchId]).firstOrNull;

    try {
      if (existingSku == null) {
        realm!.write(() {
          existingSku = _createNewSku();
          realm!.add<SKU>(existingSku!);
        });
      }
    } catch (e) {
      talker.error(e);
    }

    // Use RealmResults to continuously observe changes
    final results =
        realm!.query<SKU>(r'branchId == $0 AND consumed == false', [branchId]);

    yield* results.changes.map((event) {
      if (event.results.isEmpty) {
        // If there are no non-consumed SKUs, create a new one
        late SKU newSku;
        realm!.write(() {
          newSku = _createNewSku();
          realm!.add<SKU>(newSku);
        });
        return newSku;
      } else {
        return event.results.first;
      }
    });
  }

  @override
  List<Composite> composites({required int productId}) {
    final queryBuilder =
        realm!.query<Composite>(r'productId == $0', [productId]);

    return queryBuilder.toList();
  }

  @override
  Composite composite({required int variantId}) {
    final queryBuilder =
        realm!.query<Composite>(r'variantId == $0', [variantId]);
    return queryBuilder.first;
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName) async {
    try {
      int branchId = ProxyService.box.getBranchId()!;
      final filePath = 'public/invoices-${branchId}/$fileName.pdf';

      final result = await amplify.Amplify.Storage
          .uploadFile(
            localFile: amplify.AWSFile.fromStream(
              Stream.value(pdfData),
              size: pdfData.length,
            ),
            path: amplify.StoragePath.fromString(filePath),
            onProgress: (progress) {
              talker
                  .warning('Fraction completed: ${progress.fractionCompleted}');
            },
          )
          .result;
      return result.uploadedItem.path;
    } catch (e) {
      talker.error("Error uploading file to S3: $e");
      rethrow;
    }
  }

  @override
  List<Composite> compositesByVariantId({required int variantId}) {
    final queryBuilder =
        realm!.query<Composite>(r'variantId == $0', [variantId]);

    return queryBuilder.toList();
  }

  @override
  Tenant? tenant({int? businessId, int? userId}) {
    Tenant? tenant;

    if (businessId != null) {
      tenant =
          realm!.query<Tenant>(r'businessId == $0', [businessId]).firstOrNull;
    } else {
      tenant = realm!.query<Tenant>(r'userId == $0', [userId]).firstOrNull;
    }

    return tenant;
  }

  @override
  Stream<List<Report>> reports({required int branchId}) async* {
    final controller = StreamController<List<Report>>.broadcast();

    final query = realm!.query<Report>(r'branchId == $0', [branchId]);

    StreamSubscription<RealmResultsChanges<Report>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedReports = event.results.whereType<Report>().toList();
        if (changedReports.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    // Emit initial data
    controller.add(query.toList());

    yield* controller.stream;
  }

  @override
  Report report({required int id}) {
    return realm!.query<Report>(r'id == $0', [id]).first;
  }

  @override
  Future<({double grossProfit, double netProfit})> getReportData() async {
    // Query the Realm database
    final query = realm!
        .query<Computed>(r'branchId == $0', [ProxyService.box.getBranchId()]);

    // Check if there are any results
    if (query.isEmpty) {
      // Return default values if no data is found
      return (grossProfit: 0.0, netProfit: 0.0);
    }

    // Get the first (and presumably only) result
    final value = query.first;

    // Return the data in the required format
    return (
      grossProfit: value.grossProfit ?? 0.0,
      netProfit: value.netProfit ?? 0.0,
    );
  }

  @override
  bool isAdmin({required int userId}) {
    try {
      final Access? permission =
          realm!.query<Access>(r'userId == $0', [userId]).firstOrNull;
      return permission?.accessLevel?.toLowerCase() == "admin";
    } catch (e) {
      // Handle database errors here
      print("Error checking admin status: $e");
      return false; // Or handle the error differently based on your requirements
    }
  }

  @override
  List<Access> access({required int userId}) {
    return realm!.query<Access>(r'userId == $0 ', [userId]).toList();
  }

  @override
  List<LPermission> permissions({required int userId}) {
    return realm!.query<LPermission>(r'userId == $0 ', [userId]).toList();
  }
}
