// ignore: unused_import
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/counter.dart';
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

    List<ITransaction> transactions = await transactionsFuture();

    List<ITransaction> filteredTransactions = [];
    for (final transaction in transactions) {
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
  Future<Category?> activeCategory({required int branchId}) async {
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
  Future<void> addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item}) async {
    await realm!.putAsync<TransactionItem>(item);
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

    realm!
        .query<Tenant>(r'userId == $0 && deletedAt == nil', [userId])
        .changes
        .listen((tenants) {
          controller
              .add(tenants.results.isEmpty ? null : tenants.results.first);
        });

    await for (var tenant in controller.stream) {
      yield tenant;
    }

    // Close the StreamController after the stream is finished
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
  }

  @override
  Future<void> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType}) async {
    List<TransactionItem> items = await transactionItems(
        transactionId: transaction.id!,
        doneWithTransaction: false,
        active: true);
    realm!.writeAsync(() async {
      transaction.status = COMPLETE;
      transaction.isIncome = true;
      double subTotal = items.fold(0, (num a, b) => a + (b.price * b.qty));
      transaction.customerChangeDue = (cashReceived - subTotal);
      transaction.paymentType = paymentType;
      transaction.cashReceived = cashReceived;
      transaction.subTotal = subTotal;

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

      transaction.updatedAt = DateTime.now().toIso8601String();
      transaction.createdAt = DateTime.now().toIso8601String();

      transaction.lastTouched =
          DateTime.now().toLocal().add(Duration(hours: 2));

      //NOTE: trigger EBM, now
      TaxController(object: transaction).handleReceipt();
    });

    try {
      for (TransactionItem item in items) {
        Stock? stock = await stockByVariantId(variantId: item.variantId!);
        realm!.write(() {
          stock!.currentStock = stock.currentStock - item.qty;
          // stock value after item deduct
          stock.value = stock.currentStock * (stock.retailPrice);
          stock.action = AppActions.updated;
        });
        realm!.write(() {
          item.doneWithTransaction = true;
          item.updatedAt = DateTime.now().toIso8601String();
        });

        /// search the related product and touch them to make them as most used
        /// hence why we are adding time to it
        Variant? variant = await getVariantById(id: item.variantId!);
        Product? product = await getProduct(id: variant!.productId!);
        if (product != null) {
          realm!.write(() {
            product.lastTouched =
                DateTime.now().toLocal().add(Duration(hours: 2));
          });
        }
      }
    } catch (e, s) {
      talker.error(s);
    }

    // remove currentTransactionId from local storage to leave a room
    // for listening to new transaction that will be created
    ProxyService.box.remove(key: 'currentTransactionId');
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
      realm!.writeAsync(() => realm!.addAll(colorsToAdd));
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
      realm!.write(() {
        realm!.put<Conversation>(conversation);
      });
      return null;
    }
    if (data is Category) {
      Category category = data;
      realm!.write(() {
        realm!.put(category);
      });
      return null;
    }
    if (data is Product) {
      realm!.write(() {
        realm!.put<Product>(data);
      });
    }
    if (data is Variant) {
      realm!.write(() {
        realm!.put<Variant>(data);
      });
      return null;
    }
    if (data is Favorite) {
      realm!.write(() {
        realm!.put<Favorite>(data);
      });
      return null;
    }
    if (data is Stock) {
      realm!.write(() {
        realm!.put<Stock>(data);
      });
      return null;
    }

    if (data is Token) {
      realm!.write(() {
        realm!.put<Token>(data);
      });
      return null;
    }
    if (data is Setting) {
      realm!.write(() {
        realm!.put<Setting>(data);
      });
      return null;
    }
    if (data is EBM) {
      realm!.write(() {
        realm!.put<EBM>(data);
      });
      return null;
    }
    if (data is ITransaction) {
      realm!.write(() {
        realm!.put<ITransaction>(data);
      });
      return null;
    }
    if (data is TransactionItem) {
      realm!.write(() {
        realm!.put<TransactionItem>(data);
      });
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
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false}) async {
    final Business? business = await ProxyService.local.getBusiness();
    final int branchId = ProxyService.box.getBranchId()!;
    final int businessId = ProxyService.box.getBusinessId()!;

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
      final Variant newVariant = _createRegularVariant(
          product, branchId, business,
          qty: qty,
          supplierPrice: supplyPrice,
          retailPrice: retailPrice,
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
        resultDt: signature.resultDt ?? "");

    try {
      realm!.put<Receipt>(receipt);

      return receipt;
    } catch (error) {
      // Handle error during write operation
      throw error;
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
          realm!.delete<PColor>(color);
        });
        break;
      case 'device':
        realm!.write(() {
          Device device = realm!.query<Device>(r'id == $0 ', [id]).first;
          realm!.write(() {
            realm!.delete<Device>(device);
          });
          return false;
        });
        break;
      case 'category':
        Category category = realm!.query<Category>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete<Category>(category);
        });
        break;
      case 'product':
        Product? product = realm!.query<Product>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete<Product>(product);
        });
        break;
      case 'variant':
        Variant variant = realm!.query<Variant>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete<Variant>(variant);
        });
        break;
      case 'stock':
        Stock? stock = realm!.query<Stock>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete<Stock>(stock);
        });
        break;
      case 'setting':
        Setting setting = realm!.query<Setting>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete<Setting>(setting);
        });
        break;
      case 'pin':
        Pin? pin = realm!.query<Pin>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.delete<Pin>(pin);
        });
        break;
      case 'business':
        final business = realm!.query<Business>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.delete<Business>(business!);
        });
        break;
      case 'branch':
        final business = realm!.query<Branch>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.delete<Branch>(business!);
        });
        break;

      case 'voucher':
        final business = realm!.query<Voucher>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.delete<Voucher>(business!);
        });
        break;
      case 'transactionItem':
        TransactionItem? transactionItem =
            realm!.query<TransactionItem>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.delete<TransactionItem>(transactionItem);
        });
        break;
      case 'customer':
        Customer? customer = realm!.query<Customer>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.delete<Customer>(customer);
        });
        break;
      case 'tenant':
        final response = await flipperHttpClient
            .delete(Uri.parse("$apihub/v2/api/tenant/${id}"));
        if (response.statusCode == 200) {
          Tenant? tenant = realm!.query<Tenant>(r'id == $0 ', [id]).firstOrNull;
          realm!.write(() {
            realm!.delete<Tenant>(tenant!);
            return true;
          });
        }
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
  Future<Variant?> getCustomVariant() async {
    final branchId = ProxyService.box.getBranchId()!;
    final businessId = ProxyService.box.getBusinessId()!;

    /// Find product with name CUSTOM_PRODUCT
    Product? product = realm!.query<Product>(
        r'name == $0 AND branchId== $1 AND deletedAt == nil',
        [CUSTOM_PRODUCT, branchId]).firstOrNull;

    if (product == null) {
      // Create a new custom product if it doesn't exist
      product = await createProduct(
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
      variant = await _addMissingVariant(variant, product, branchId);
    }

    return variant;
  }

  @override
  Future<Customer?> getCustomer({String? key, int? id}) async {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).firstOrNull;
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'(custNm CONTAINS $1 OR email CONTAINS $1 OR telNo CONTAINS $1) AND deletedAt == nil',
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
  Future<Drawers?> getDrawer({required int cashierId}) async {
    return realm!.query<Drawers>(
        r'open == true AND cashierId == $0', [cashierId]).firstOrNull;
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
  Future<Product?> getProduct({required int id}) async {
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
  Future<ITransaction?> getTransactionById({required int id}) async {
    return realm!.query<ITransaction>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) async {
    return realm!.query<TransactionItem>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId}) async {
    return realm!.query<TransactionItem>(
        r'variantId == $0 AND transactionId == $1 AND deletedAt == nil',
        [variantId, transactionId]).firstOrNull;
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) async {
    return realm!.query<TransactionItem>(
        r'transactionId == $0 AND deletedAt == nil', [transactionId]).toList();
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
  Future<Variant?> getVariantById({required int id}) async {
    return realm!
        .query<Variant>(r'id == $0 AND deletedAt == nil', [id]).firstOrNull;
  }

  @override
  Future<List<Variant>> getVariantByProductId({int? productId}) async {
    return realm!.query<Variant>(
        r'productId == $0 AND deletedAt == nil', [productId]).toList();
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
  Future<bool> isDrawerOpen({required int cashierId}) async {
    return realm!.query<Drawers>(
            r'cashierId == $0 AND deletedAt == nil', [cashierId]).firstOrNull !=
        null;
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled() {
    final businessId = ProxyService.box.getBusinessId();
    final Business? business =
        ProxyService.local.getBusiness(businessId: businessId);
    //&& business?.bhfId != null
    return business?.tinNumber != null;
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

  // @override
  // Future<void> loadCounterFromOnline({required int businessId}) async {
  //   final http.Response response = await flipperHttpClient
  //       .get(Uri.parse("$apihub/v2/api/counter/$businessId"));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonResponse = json.decode(response.body);
  //     List<ICounter> counters = ICounter.fromJsonList(jsonResponse);

  //     /// first check if we don't have local counter that we are overwriting
  //     List<Counter> localCounters =
  //         realm!.query<Counter>(r'businessId == $0', [businessId]).toList();
  //     if (localCounters.isNotEmpty) return;
  //     for (ICounter counter in counters) {
  //       realm!.put<Counter>(Counter(ObjectId(),
  //           id: counter.id,
  //           branchId: counter.branchId,
  //           businessId: counter.businessId,
  //           totRcptNo: counter.totRcptNo,
  //           curRcptNo: counter.curRcptNo,
  //           receiptType: counter.receiptType));
  //     }
  //   } else {
  //     throw InternalServerError(term: "Error loading the counters");
  //   }
  // }

  @override
  Future<void> logOutLight() {
    // TODO: implement logOutLight
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType}) async {
    int branchId = ProxyService.box.getBranchId()!;

    ITransaction? existTransaction = await pendingTransaction(
        branchId: branchId, transactionType: transactionType);

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
  Future<ITransaction> manageTransaction(
      {required String transactionType}) async {
    int branchId = ProxyService.box.getBranchId()!;
    ITransaction? existTransaction = await pendingTransaction(
        branchId: branchId, transactionType: transactionType);
    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(ObjectId(),
          lastTouched: DateTime.now(),
          id: id,
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
      await realm!.putAsync<ITransaction>(transaction);

      ProxyService.box.writeInt(key: 'currentTransactionId', value: id);
      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) async {
    await realm!.writeAsync(() async {
      realm!.putAsync<Drawers>(drawer);
    });
    return realm!.query<Drawers>(
        r'id == $0 AND deletedAt == nil', [drawer.id]).firstOrNull;
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

  @override
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType}) async {
    return realm!.query<ITransaction>(
        r'branchId == $0 AND transactionType == $1 AND status == $2',
        [branchId, transactionType, PENDING]).firstOrNull;
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
  Future<Stock?> stockByVariantId(
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
    String queryString = "";

    queryString = r'''deletedAt = nil
        && status == $0
        && (
        transactionType IN ANY {'PARKED'} && branchId == $1
        )
        ''';

    final subject = ReplaySubject<List<ITransaction>>();

    final query = realm!.query<ITransaction>(queryString, [PARKED, branchId]);

    query.changes.listen((results) {
      subject.add(results.results.toList());
    });

    return subject.stream;
  }

  @override
  Future<List<TransactionItem>> transactionItems(
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
    if (startDate == null || endDate == null) return Stream.empty();
    final controller = StreamController<List<ITransaction>>.broadcast();

    /// This is a hack as the query is failing to include data that is on same endDate
    /// so to include it I have to add 1 day to a provided endDate

    /// Ref: https://stackoverflow.com/questions/74956925/querying-realm-in-flutter-using-datetime
    final query = realm!.query<ITransaction>(
        r'lastTouched >= $0 && lastTouched <= $1 && status == $2',
        [startDate.toUtc(), endDate.add(Duration(days: 1)).toUtc(), COMPLETE]);

    StreamSubscription<RealmResultsChanges<ITransaction>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants =
            event.results.whereType<ITransaction>().toList();
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
  Future<List<ITransaction>> transactionsFuture(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) async {
    String queryString = "";
    if (isCashOut) {
      queryString = r'''deletedAt = nil
            && status == $0
            && (
            isExpense ==true && branchId == $1
            )
            ''';
    } else {
      queryString = r'''deletedAt = nil
            && status == $0
            && (
            isIncome==true && branchId == $1
            )
            ''';
    }
    return realm!.query<ITransaction>(
        queryString, [status ?? 'COMPLETE', branchId]).toList();
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
      queryString = r'''deletedAt = nil
            && status == $0
            && (
            transactionType IN ANY {'Cash Out'} && branchId == $1
            )
            ''';
    } else {
      queryString = r'''deletedAt = nil
            && status == $0
            && (
            transactionType IN ANY {'Cash In', 'sale', 'custom', 'Online Sale','Cash Out','Salary','Transport','Airtime'} && branchId == $1
            )
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
  Future<Variant?> variant({int? variantId, String? name}) async {
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
  Future<String> dbPath({required String path}) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final realmDirectory = '${appDocsDirectory.path}/v10';

    // Create the directory if it doesn't exist
    final directory = Directory(realmDirectory);
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    final String fileName = '${path}.db'; // Fixed, user-friendly name

    return "$realmDirectory/$fileName";
  }

  /// when opening db we carefully fail gracefuly when especially on startup we use in memory db
  /// then when user login the real db is used
  /// it is very important to avoid issue where we are saving in memory thinking that we using synced db hence why we call init on startupview model
  /// to re-configure the db now for this time not using the in-memory db.

  @override
  Future<RealmApiInterface> configure(
      {required bool useInMemoryDb, bool useFallBack = false}) async {
    _setApiEndpoints();

    final app = App(AppConfiguration(AppSecrets.appId,
        baseUrl: Uri.parse("https://services.cloud.mongodb.com")));

    realm?.close();

    User user = app.currentUser ??
        await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));

    /// do not provide fallback if the user is not authenticated.
    if (useFallBack) {
      realm?.close();
      _configureInMemory();
      return this;
    }

    try {
      if (useInMemoryDb) {
        realm?.close();
        _configureInMemory();
      } else {
        if (ProxyService.box.encryptionKey().isEmpty) {
          throw Exception("null encryption");
        }
        realm?.close();
        String path = await dbPath(path: 'synced');
        await _configurePersistent(user, path);
      }
    } catch (e, s) {
      /// after a lof of thinking a fallback should use in memory because
      /// we can not think of Ream(config) will be totally different from Realm.open()
      /// hence I can not provide different encryption key on either
      talker.error(s);
    }
    return this;
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

  void _configureInMemory() {
    Configuration config = Configuration.inMemory(realmModels);
    realm = Realm(config);
    talker.info("Opened in-memory realm.");
  }

  Future<void> _configurePersistent(User user, String path) async {
    CancellationToken token = CancellationToken();
    Future<void>.delayed(
        const Duration(seconds: 30),
        () => token.cancel(CancelledException(
            cancellationReason: "Realm took too long to open")));
    talker.warning("opening persistent");
    // Sentry.captureMessage("opening persistent");
    Configuration config = await _createPersistentConfig(user, path);
    realm = await _openRealm(config);

    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;

    await updateSubscription(branchId, businessId);
    await realm!.subscriptions.waitForSynchronization(token);
  }

  Future<Configuration> _createPersistentConfig(User user, String path) async {
    return Configuration.flexibleSync(
      user,
      realmModels,
      encryptionKey: ProxyService.box.encryptionKey().toIntList(),
      path: path,
      clientResetHandler:
          RecoverUnsyncedChangesHandler(onBeforeReset: (beforeResetRealm) {
        log("reset requested here..");
      }),
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
    );
  }

  Future<Realm> _openRealm(Configuration config) async {
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
      } else {
        talker.info("Opened realm with no internet access.");
        return Realm(config);
      }
    } catch (e) {
      return Realm(config);
    }
  }

  Future<void> updateSubscription(int? branchId, int? businessId) async {

    for(Subscription sub in realm!.subscriptions){
      talker.warning(sub.name );
    }

    if (realm == null || businessId == null || branchId == null) return;
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
    final permission = realm!.all<LPermission>();

    final pin = realm!.query<Pin>(
        r'userId == $0', [ProxyService.box.getUserId()?.toString()]);

    // fake subscription as I normally do not these model synced accros devices but I don't know how I can pause one model
    final token = realm!.query<Token>(r'businessId == $0', [businessId]);
    final tenant = realm!.all<Tenant>();
    final favorites = realm!.query<Favorite>(r'branchId == $0', [branchId]);
    final drawers = realm!.query<Drawers>(r'cashierId == $0', [businessId]);

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
      mutableSubscriptions.add(drawers, name: "drawers",update: true);
      mutableSubscriptions.add(token,name:"token");

      mutableSubscriptions.add(tenant, name: "tenant-${businessId}",update: true);
      mutableSubscriptions.add(permission, name: "permission-${businessId}",update: true);
      mutableSubscriptions.add(pin, name: "pin-${businessId}",update: true);
      mutableSubscriptions.add(units, name: "units-${businessId}",update: true);
      mutableSubscriptions.add(receipts, name: "favorites-${businessId}",update: true);
      mutableSubscriptions.add(favorites, name: "favorites-${branchId}",update: true);
      mutableSubscriptions.add(ebms, name: "ebms-${businessId}",update: true);
      mutableSubscriptions.add(devices, name: "devices-${businessId}",update: true);
      mutableSubscriptions.add(conversations, name: "conversations-${businessId}",update: true);
      mutableSubscriptions.add(colors, name: "colors-${businessId}",update: true);
      mutableSubscriptions.add(category, name: "category-${businessId}",update: true);
      mutableSubscriptions.add(customer, name: "iCustomer-${branchId}",update: true);
      mutableSubscriptions.add(product, name: "iProduct-${branchId}",update: true);
      mutableSubscriptions.add(counter, name: "iCounter-${branchId}",update: true);
      mutableSubscriptions.add(variant, name: "iVariant-${branchId}",update: true);
      mutableSubscriptions.add(stock, name: "iStock-${branchId}",update: true);
      mutableSubscriptions.add(unit, name: "iUnit-${branchId}",update: true);
      mutableSubscriptions.add(transaction, name: "transaction-${branchId}",update: true);
      mutableSubscriptions.add(transactionItem, name: "transactionItem-${branchId}",update: true);
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
  }

  Variant _createRegularVariant(
      Product product, int branchId, Business? business,
      {required double qty,
      required double supplierPrice,
      required double retailPrice,
      required int itemSeq,
      required bool ebmSynced}) {
    final int variantId = randomNumber();
    final number = randomNumber().toString().substring(0, 5);
    return Variant(ObjectId(),
        lastTouched: DateTime.now(),
        name: product.name,
        sku: 'sku',
        action: 'create',
        productId: product.id!,
        color: product.color,
        unit: 'Per Item',
        productName: product.name,
        branchId: branchId,
        supplyPrice: supplierPrice,
        retailPrice: retailPrice,
        id: variantId,
        isTaxExempted: false,
        bhfId: business?.bhfId ?? '00',
        itemStdNm: "Regular",
        addInfo: "A",
        pkg: "1",
        splyAmt: supplierPrice,
        itemClsCd:
            "5020230602", // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
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
        itemSeq: itemSeq,
        itemNm: product.name,
        taxPercentage: 18.0,
        tin: business!.tinNumber,
        bcd: product.name,

        /// country of origin for this item we default until we support something different
        /// and this will happen when we do import.
        orgnNatCd: "RW",

        /// registration name
        regrNm: product.name,

        /// taxation type code
        taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
        // default unit price
        dftPrc: 0,
        prc: 1,

        // NOTE: I believe bellow item are required when saving purchase
        ///but I wonder how to get them when saving an item.
        spplrItemCd: randomNumber().toString().substring(0, 5),
        spplrItemClsCd: randomNumber().toString().substring(0, 5),
        spplrItemNm: product.name,

        /// Packaging Unit
        qtyUnitCd: "U", // see 4.6 in doc
        ebmSynced: ebmSynced);
  }

  _findProductByBusinessId({required String name, required int businessId}) {
    return realm!.query<Product>(
        r'businessId == $0 AND name == $1', [businessId, name]).firstOrNull;
  }

  Future<Variant?> _addMissingVariant(
      Variant? variant, Product? product, int branchId) async {
    Business? business = await ProxyService.local.getBusiness();
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
            bhfId: business.bhfId ?? '00',
            isTaxExempted: false,
            itemClsCd:
                "5020230602", // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
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
            tin: business.tinNumber,
            bcd: variant!.name,

            /// country of origin for this item we default until we support something different
            /// and this will happen when we do import.
            orgnNatCd: "RW",

            /// registration name
            regrNm: variant.name,

            /// taxation type code
            taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
            // default unit price
            dftPrc: variant.retailPrice,

            // NOTE: I believe bellow item are required when saving purchase
            ///but I wonder how to get them when saving an item.
            spplrItemCd: randomNumber().toString().substring(0, 5),
            spplrItemClsCd: randomNumber().toString().substring(0, 5),
            spplrItemNm: variant.name);

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
    } catch (e) {
      // Handle error during write operation
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
        throw ErrorReadingFromYBServer(term: response.body);
      } else {
        throw ErrorReadingFromYBServer(term: response.body);
      }
    } catch (error) {
      throw ErrorReadingFromYBServer(term: error.toString());
    }
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
    final controller = StreamController<double>.broadcast();

    final query = realm!.all<TransactionItem>();

    StreamSubscription<RealmResultsChanges<TransactionItem>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<TransactionItem>().toList();
        double totalSoldValue = 0;
        for (var transaction in changedTransactions) {
          // Assuming each TransactionItem has a property representing sold value
          totalSoldValue += transaction.price;
        }
        controller.add(totalSoldValue);
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Stream<double> stockValue({required branchId}) async* {
    final controller = StreamController<double>.broadcast();

    final query = realm!.query<Stock>('currentStock > 0');

    StreamSubscription<RealmResultsChanges<Stock>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        double totalStockValue = 0;
        for (var stock in event.results) {
          // Calculate the total value of each stock item and sum them up
          totalStockValue += stock.currentStock * stock.retailPrice;
        }
        controller.add(totalStockValue);
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
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
  Future<RwApiResponse> selectImportItems(
      {required int tin, required String bhfId, required String lastReqDt}) {
    return ProxyService.tax
        .selectImportItems(tin: tin, bhfId: bhfId, lastReqDt: lastReqDt);
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
    ProxyService.box.clear();
    await firebase.FirebaseAuth.instance.signOut();
    // await firebase.FirebaseAuth.instance.currentUser?.getIdToken(true);
    return Future.value(true);
  }
}
