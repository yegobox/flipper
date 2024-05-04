// ignore: unused_import
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/isar/business_type.dart';
import 'package:flipper_models/isar/counter.dart';
import 'package:flipper_models/isar/iuser.dart';
import 'package:flipper_models/isar/permission.dart';
import 'package:flipper_models/isar/pin.dart';
import 'package:flipper_models/isar/social_token.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_routing/receipt_types.dart';
import 'package:flipper_services/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'isar/branch.dart';
import 'isar/business.dart';
import 'isar/tenant.dart';
import 'package:realm/realm.dart';
import 'package:flutter/foundation.dart' as foundation;

class RealmAPI<M extends IJsonSerializable>
    implements SyncReaml<M>, RealmApiInterface {
  Realm? realm;
  final talker = TalkerFlutter.init();
  late String apihub;
  late String commApi;

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) {
    // TODO: implement getTransactionsAmountsSum
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
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments) {
    if (realm == null) return null;
    final results = realm!.query<T>(query, arguments);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  @override
  Future<Branch> activeBranch() async {
    return realm!.query<Branch>(r'isDefault == $0', [true]).first;
  }

  @override
  Future<Category?> activeCategory({required int branchId}) async {
    return realm!.query<Category>(
        r'focused == $0 && active == $1 && branchId == $2 && deletedAt == nil',
        [true, true, branchId]).firstOrNull;
  }

  @override
  Future<Customer?> addCustomer({
    required Customer customer,
    required int transactionId,
  }) async {
    try {
      // Open a write transaction
      realm!.write(() {
        // Add the customer to the Realm
        realm!.put(customer);

        // Get the transaction from Realm
        final transaction =
            realm!.all<ITransaction>().firstWhere((t) => t.id == transactionId);

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
        await realm!.write(() {
          realm!.put<Favorite>(data);
        });
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
    Stock stock = Stock(
      ObjectId(),
      retailPrice: variant.retailPrice,
      supplyPrice: variant.supplyPrice,
      id: randomNumber(),
      productId: variant.productId,
      variantId: variant.id,
      branchId: variant.branchId,
    );
    try {
      realm!.write(() {
        realm!.put<Stock>(stock);
      });
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
    talker.info(item.toEJson());
    realm!.write(() => realm!.put<TransactionItem>(item));
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      // Open a write transaction
      realm!.write(() {
        for (Map map in units) {
          final unit = IUnit(
            ObjectId(),
            active: map['active'],
            branchId: branchId,
            id: randomNumber(),
            name: map['name'],
            action: AppActions.created,
            lastTouched: DateTime.now(),
            value: map['value'],
          );

          // Add the unit to Realm
          realm!.put<IUnit>(unit);
        }
      });

      return 200; // Return a success code
    } catch (e) {
      print('Failed to add units: $e');
      rethrow;
    }
  }

  @override
  Future<int> addVariant({required List<Variant> variations}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      // Open a write transaction
      realm!.write(() {
        for (final variation in variations) {
          _processVariant(branchId, variation);
        }
      });

      return 200;
    } catch (e) {
      print('Failed to add variants: $e');
      rethrow;
    }
  }

  @override
  Future<void> assignCustomerToTransaction({
    required int customerId,
    int? transactionId,
  }) async {
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
        .query<Tenant>(
          r'userId == $0 && deletedAt == nil',
          [userId],
        )
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
      final product = realm!.query<Product>(
        r'id == $0 ',
        [productId],
      ).firstOrNull;

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
  Future<List<Branch>> branches({int? businessId}) async {
    if (businessId != null) {
      return realm!.query<Branch>(
        r'businessId == $0 ',
        [businessId],
      ).toList();
    } else {
      throw Exception("BusinessId is required");
    }
  }

  @override
  Future<List<Business>> businesses({int? userId}) async {
    List<Business> businesses = [];
    if (userId != null) {
      businesses = realm!.query<Business>(
        r'userId == $0 ',
        [userId],
      ).toList();
    } else {
      throw Exception("userId is required");
    }

    return businesses;
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    //  return  realm!categorys.filter().branchIdEqualTo(branchId).findAll();
    return realm!.query<Category>(
      r'branchId == $0 ',
      [branchId],
    ).toList();
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
    transaction.status = COMPLETE;

    List<TransactionItem> items = await transactionItems(
        transactionId: transaction.id!,
        doneWithTransaction: false,
        active: true);
    double subTotal = items.fold(0, (num a, b) => a + (b.price * b.qty));
    transaction.customerChangeDue = (cashReceived - subTotal);
    transaction.paymentType = paymentType;
    transaction.cashReceived = cashReceived;
    transaction.subTotal = subTotal;

    /// for now receipt type to be printed is in box shared preference
    /// this ofcause has limitation that if more than two users are using device
    /// one user will use configuration set by probably a different user, this need to change soon.
    String receiptType = "ns";
    if (ProxyService.box.isPoroformaMode()) {
      receiptType = ReceiptType.ps;
    }
    if (ProxyService.box.isTrainingMode()) {
      receiptType = ReceiptType.ts;
    }
    transaction.receiptType = receiptType;

    /// refresh created as well to reflect when this transaction was created and completed

    transaction.updatedAt = DateTime.now().toIso8601String();
    transaction.createdAt = DateTime.now().toIso8601String();
    log(DateTime.now().toLocal().add(Duration(hours: 2)).toString(),
        name: "LocalDate");
    transaction.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));

    await update(data: transaction);

    for (TransactionItem item in items) {
      Stock? stock = await stockByVariantId(variantId: item.variantId!);
      stock!.currentStock = stock.currentStock - item.qty;
      // stock value after item deduct
      stock.value = stock.currentStock * (stock.retailPrice);
      stock.action = AppActions.updated;
      item.doneWithTransaction = true;
      item.updatedAt = DateTime.now().toIso8601String();
      await update(data: stock);
      await update(data: item);
      // search the related product and touch them to make them as most used
      Variant? variant = await getVariantById(id: item.variantId!);
      Product? product = await getProduct(id: variant?.productId ?? 0);
      if (product != null) {
        product.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
        await update(data: product);
      }
    }
    // remove currentTransactionId from local storage to leave a room
    // for listening to new transaction that will be created
    ProxyService.box.remove(key: 'currentTransactionId');
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return realm!.query<PColor>(
      r'branchId == $0 ',
      [branchId],
    ).toList();
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) async {
    return realm!.query<ITransaction>(
      r'status == $0 && branchId == $1',
      [COMPLETE, branchId],
    ).toList();
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
  Future<Product?> createProduct(
      {required Product product, bool skipRegularVariant = false}) async {
    final Business? business = await getBusiness();
    final int branchId = ProxyService.box.getBranchId()!;
    final int businessId = ProxyService.box.getBusinessId()!;

    // Check if the product created (custom or temp) already exists and return it
    final String productName = product.name!;
    if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
      final Product? existingProduct = await _findProductByBusinessId(
        name: productName,
        businessId: businessId,
      );
      if (existingProduct != null) {
        return existingProduct;
      }
    }
    realm!.write(() {
      realm!.put<Product>(product);

      if (!skipRegularVariant) {
        final Product kProduct = realm!.query<Product>(
          r'id == $0 ',
          [product.id],
        ).first;

        // Create a Regular Variant
        final Variant newVariant =
            _createRegularVariant(product, branchId, business);
        realm!.put<Variant>(newVariant);

        // Create a Stock for the Regular Variant
        final Stock stock = Stock(
          ObjectId(),
          lastTouched: DateTime.now(),
          id: randomNumber(),
          action: 'create',
          branchId: branchId,
          variantId: newVariant.id!,
          currentStock: 0.0,
          productId: kProduct.id!,
        );
        realm!.put<Stock>(stock);
      }
    });

    return realm!.query<Product>(
      r'id == $0 ',
      [product.id],
    ).firstOrNull;
  }

  @override
  Future<Receipt?> createReceipt(
      {required EBMApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter}) async {
    int branchId = ProxyService.box.getBranchId()!;

    Receipt receipt = Receipt(
      ObjectId(),
      id: randomNumber(), // Consider using a more robust ID generation
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
      resultDt: signature.resultDt ?? "",
    );

    try {
      realm!.write(() {
        realm!.put<Receipt>(receipt);
      });
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
    return realm!.query<Customer>(
      r'branchId == $0 ',
      [branchId],
    ).toList();
  }

  @override
  String dbPath() {
    // TODO: implement dbPath
    throw UnimplementedError();
  }

  @override
  Future<Branch?> defaultBranch() async {
    return realm!.query<Branch>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Business?> defaultBusiness() async {
    return realm!.query<Business>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  FlipperHttpClient flipperHttpClient = FlipperHttpClient(http.Client());

  @override
  Future<bool> delete({required int id, String? endPoint}) async {
    final DateTime deletionTime = DateTime.now();

    switch (endPoint) {
      case 'color':
        realm!.write(() {
          PColor? color = realm!.query<PColor>(r'id == $0 ', [id]).firstOrNull;

          if (color != null) {
            color.deletedAt = deletionTime;
            color.action = AppActions.deleted;

            return true;
          }
          return false;
        });
        break;
      case 'device':
        realm!.write(() {
          Device? device = realm!.query<Device>(r'id == $0 ', [id]).firstOrNull;
          if (device != null) {
            device.deletedAt = deletionTime;
            device.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'category':
        realm!.write(() {
          Category? category =
              realm!.query<Category>(r'id == $0 ', [id]).firstOrNull;
          if (category != null) {
            category.deletedAt = deletionTime;
            category.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'product':
        realm!.write(() {
          Product? product =
              realm!.query<Product>(r'id == $0 ', [id]).firstOrNull;
          if (product != null) {
            product.deletedAt = deletionTime;
            product.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'variant':
        realm!.write(() {
          Variant? variant =
              realm!.query<Variant>(r'id == $0 ', [id]).firstOrNull;
          if (variant != null) {
            variant.deletedAt = deletionTime;
            variant.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'stock':
        realm!.write(() {
          Stock? stocks = realm!.query<Stock>(r'id == $0 ', [id]).firstOrNull;
          if (stocks != null) {
            stocks.deletedAt = deletionTime;
            stocks.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'setting':
        realm!.write(() {
          Setting? setting =
              realm!.query<Setting>(r'id == $0 ', [id]).firstOrNull;
          if (setting != null) {
            setting.deletedAt = deletionTime;
            setting.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'pin':
        realm!.write(() {
          Pin? pin = realm!.query<Pin>(r'id == $0 ', [id]).firstOrNull;
          if (pin != null) {
            realm!.delete<Pin>(pin);
            return true;
          }
          return false;
        });
        break;
      case 'business':
        realm!.write(() {
          final business =
              realm!.query<Business>(r'id == $0 ', [id]).firstOrNull;
          realm!.delete<Business>(business!);
        });
        break;
      case 'branch':
        realm!.write(() {
          final business = realm!.query<Branch>(r'id == $0 ', [id]).firstOrNull;
          realm!.delete<Branch>(business!);
        });
        break;

      case 'voucher':
        realm!.write(() {
          final business =
              realm!.query<Voucher>(r'id == $0 ', [id]).firstOrNull;
          realm!.delete<Voucher>(business!);
        });
        break;
      case 'transactionItem':
        realm!.write(() {
          TransactionItem? transactionItems =
              realm!.query<TransactionItem>(r'id == $0 ', [id]).firstOrNull;
          ;
          if (transactionItems != null) {
            transactionItems.deletedAt = deletionTime;
            transactionItems.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'customer':
        realm!.write(() {
          Customer? customer =
              realm!.query<Customer>(r'id == $0 ', [id]).firstOrNull;
          if (customer != null) {
            customer.deletedAt = deletionTime;
            customer.action = AppActions.deleted;
            return true;
          }
          return false;
        });
        break;
      case 'tenant':
        final response = await flipperHttpClient.delete(
          Uri.parse("$apihub/v2/api/tenant/${id}"),
        );
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
      r'favIndex == $0 && deletedAt == null ',
      [favIndex],
    ).first;
    realm!.write(() {
      realm!.delete<Favorite>(favorite);
    });
    return Future.value(200);
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) async {
    final transaction = realm!.query<ITransaction>(
      r'id == $0 && deletedAt == null ',
      [transactionIndex],
    ).first;
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
    return realm!.query<Product>(
      r'bindedToTenantId == $0',
      [tenantId],
    ).firstOrNull;
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
  Future<Business> getBusiness({int? businessId}) async {
    if (businessId != null) {
      return realm!.query<Business>(r'id == $0', [businessId]).first;
    } else {
      ///FIXME: what will happen if a user has multiple business associated to him
      ///the code bellow suggest that the first in row will be returned which can be wrong.
      int? userId = ProxyService.box.getUserId();
      return realm!.query<Business>(r'userId == $0', [userId]).first;
    }
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business = realm!.query<Business>(r'id == $0', [id]).firstOrNull;

    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      IBusiness iBusiness = IBusiness.fromJson(json.decode(response.body));
      Business business = Business(
        ObjectId(),
        id: iBusiness.id,
        name: iBusiness.name,
        userId: iBusiness.userId,
        createdAt: DateTime.now().toIso8601String(),
      );

      business.id = id;
      realm!.write(() {
        realm!.put<Business>(business);
      });
      return business;
    }
    return null;
  }

  @override
  Future<PColor?> getColor({required int id}) async {
    return realm!.query<PColor>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<List<Business>> getContacts() async {
    return realm!.query<Business>(
        r'userId == $0', [ProxyService.box.getUserId()]).toList();
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) {
    // TODO: implement getConversation
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) async {
    return realm!.query<Counter>(
        r'branchId == $0 AND receiptType == $1 AND deletedAt == nil',
        [branchId, receiptType]).firstOrNull;
  }

  @override
  Future<Variant?> getCustomVariant() async {
    final branchId = ProxyService.box.getBranchId()!;
    final businessId = ProxyService.box.getBusinessId()!;

    // Find product with name CUSTOM_PRODUCT
    Product? product = realm!.query<Product>(
        r'name == $0 AND branchId== $1 AND deletedAt == nil',
        [CUSTOM_PRODUCT, branchId]).firstOrNull;

    if (product == null) {
      // Create a new custom product if it doesn't exist
      product = await createProduct(
        product: Product(
          ObjectId(),
          id: randomNumber(),
          lastTouched: DateTime.now(),
          name: CUSTOM_PRODUCT,
          action: 'create',
          businessId: businessId,
          color: "#e74c3c",
          createdAt: DateTime.now().toIso8601String(),
          branchId: businessId,
        ),
      );
    }

    // Find variant associated with the custom product
    Variant? variant =
        realm!.query<Variant>(r'productId == $0 ', [product!.id]).firstOrNull;

    if (variant == null) {
      // If the variant doesn't exist, add it
      variant = await _addMissingVariant(
        variant,
        product,
        branchId,
      );
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
      return realm!.query<Customer>(
        r'id == $0',
        [id],
      ).firstOrNull;
    } else if (key != null) {
      final customer = realm!.query<Customer>(
        r'(custNm CONTAINS $1 OR email CONTAINS $1 OR telNo CONTAINS $1) AND deletedAt == nil',
        [key],
      ).firstOrNull;
      return customer;
    } else {
      return null;
    }
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) async* {
    realm!
        .query<Tenant>(
          r'businessId == $0 AND deletedAt == nil',
          [businessId],
        )
        .changes
        .listen((_) async* {
          yield realm!.query<Tenant>(
            r'businessId == $0 AND deletedAt == nil',
            [businessId],
          ).firstOrNull;
        });
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    // get device from realm with linking code and return it
    return realm!.query<Device>(
      r'phone == $0 AND linkingCode == $1 AND deletedAt == nil',
      [phone, linkingCode],
    ).firstOrNull;
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    // get device from realm with id and return it
    return realm!.query<Device>(
      r'id == $0',
      [id],
    ).firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    // get device from realm with linking code and return it
    return realm!.query<Device>(
      r'businessId == $0 AND deletedAt == nil',
      [businessId],
    ).toList();
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) async {
    return realm!.query<Discount>(
      r'branchId == $0',
      [branchId],
    ).toList();
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    return realm!.query<Drawers>(
      r'open == true AND cashierId == $0',
      [cashierId],
    ).firstOrNull;
  }

  @override
  Future<EBM?> getEbmByBranchId({required int branchId}) async {
    return realm!.query<EBM>(
      r'branchId == $0',
      [branchId],
    ).firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    // Get a favorite
    return realm!.query<Favorite>(
      r'id == $0 AND deletedAt == nil',
      [favId],
    ).firstOrNull;
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
          .query<Favorite>(
            r'favIndex == $0 AND deletedAt == nil',
            [favIndex],
          )
          .changes
          .listen((_) async* {
            yield realm!.query<Favorite>(
              r'favIndex == $0 AND deletedAt == nil',
              [favIndex],
            ).firstOrNull;
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
      r'productId == $0 AND deletedAt == nil',
      [prodId],
    ).firstOrNull;
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    return realm!
        .query<Favorite>(
          r'deletedAt == nil',
        )
        .toList();
  }

  @override
  Future<Business> getOnlineBusiness({required int userId}) async {
    final response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw BusinessNotFoundException(term: "IBusiness not found");
    }

    Business? business = realm!.query<Business>(r'id == $0',
        [IBusiness.fromJson(json.decode(response.body)).id!]).firstOrNull;

    if (business == null) {
      realm!.write(() {
        realm!.put<Business>(
          Business(
            ObjectId(),
            id: IBusiness.fromJson(json.decode(response.body)).id,
            userId: IBusiness.fromJson(json.decode(response.body)).userId,
            name: IBusiness.fromJson(json.decode(response.body)).name,
            currency: IBusiness.fromJson(json.decode(response.body)).currency,
            categoryId:
                IBusiness.fromJson(json.decode(response.body)).categoryId,
            latitude: IBusiness.fromJson(json.decode(response.body)).latitude,
            longitude: IBusiness.fromJson(json.decode(response.body)).longitude,
            timeZone: IBusiness.fromJson(json.decode(response.body)).timeZone,
            country: IBusiness.fromJson(json.decode(response.body)).country,
            businessUrl:
                IBusiness.fromJson(json.decode(response.body)).businessUrl,
            hexColor: IBusiness.fromJson(json.decode(response.body)).hexColor,
            imageUrl: IBusiness.fromJson(json.decode(response.body)).imageUrl,
            type: IBusiness.fromJson(json.decode(response.body)).type,
            active: IBusiness.fromJson(json.decode(response.body)).active,
            chatUid: IBusiness.fromJson(json.decode(response.body)).chatUid,
            metadata: IBusiness.fromJson(json.decode(response.body)).metadata,
            role: IBusiness.fromJson(json.decode(response.body)).role,
            lastSeen: IBusiness.fromJson(json.decode(response.body)).lastSeen,
            firstName: IBusiness.fromJson(json.decode(response.body)).firstName,
            lastName: IBusiness.fromJson(json.decode(response.body)).lastName,
            createdAt: IBusiness.fromJson(json.decode(response.body)).createdAt,
            deviceToken:
                IBusiness.fromJson(json.decode(response.body)).deviceToken,
            backUpEnabled:
                IBusiness.fromJson(json.decode(response.body)).backUpEnabled,
            subscriptionPlan:
                IBusiness.fromJson(json.decode(response.body)).subscriptionPlan,
            nextBillingDate:
                IBusiness.fromJson(json.decode(response.body)).nextBillingDate,
            previousBillingDate: IBusiness.fromJson(json.decode(response.body))
                .previousBillingDate,
            isLastSubscriptionPaymentSucceeded:
                IBusiness.fromJson(json.decode(response.body))
                    .isLastSubscriptionPaymentSucceeded,
            backupFileId:
                IBusiness.fromJson(json.decode(response.body)).backupFileId,
            email: IBusiness.fromJson(json.decode(response.body)).email,
            lastDbBackup:
                IBusiness.fromJson(json.decode(response.body)).lastDbBackup,
            fullName: IBusiness.fromJson(json.decode(response.body)).fullName,
            tinNumber: IBusiness.fromJson(json.decode(response.body)).tinNumber,
            bhfId: IBusiness.fromJson(json.decode(response.body)).bhfId,
            dvcSrlNo: IBusiness.fromJson(json.decode(response.body)).dvcSrlNo,
            adrs: IBusiness.fromJson(json.decode(response.body)).adrs,
            taxEnabled:
                IBusiness.fromJson(json.decode(response.body)).taxEnabled,
            taxServerUrl:
                IBusiness.fromJson(json.decode(response.body)).taxServerUrl,
            isDefault: IBusiness.fromJson(json.decode(response.body)).isDefault,
            businessTypeId:
                IBusiness.fromJson(json.decode(response.body)).businessTypeId,
            lastTouched:
                IBusiness.fromJson(json.decode(response.body)).lastTouched,
            action: IBusiness.fromJson(json.decode(response.body)).action,
            deletedAt: IBusiness.fromJson(json.decode(response.body)).deletedAt,
            encryptionKey:
                IBusiness.fromJson(json.decode(response.body)).encryptionKey,
          ),
        );
      });
      // business =
      //     await realm.iBusiness.filter().userIdEqualTo(userId).findFirst();
      business = realm!.query<Business>(r'userId == $0', [userId]).firstOrNull;
    }
    ProxyService.box.writeInt(key: 'businessId', value: business!.id!);

    return business;
  }

  @override
  Future<Product?> getProduct({required int id}) async {
    return realm!.query<Product>(
      r'id == $0 AND deletedAt == nil',
      [id],
    ).firstOrNull;
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return realm!.query<Product>(
      r'barCode == $0 AND deletedAt == null AND branchId ==$1',
      [barCode, branchId],
    ).firstOrNull;
  }

  @override
  Future<List<Product?>> getProductByName({required String name}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return realm!.query<Product>(
      r'name STARTSWITH[c] $0 OR name CONTAINS[c] $0 OR name ENDSWITH[c] $0 AND deletedAt == null AND branchId == $1',
      [name, branchId],
    ).toList();
  }

  @override
  Future<List<Product>> getProductList({int? prodIndex}) async {
    int branchId = ProxyService.box.getBranchId()!;

    // No need for completer as Realm provides built-in async support
    final queryBuilder = realm!.query<Product>(
      r'branchId == $0  AND id =  $1 AND deletedAt == nil',
      [branchId, prodIndex],
    );

    return queryBuilder.toList();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) async {
    return realm!.query<Receipt>(
      r'transactionId == $0 AND deletedAt == nil',
      [transactionId],
    ).firstOrNull;
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
      [variantId, branchId],
    ).firstOrNull;
  }

  @override
  Future<Stock?> getStockById({required int id}) async {
    return realm!.query<Stock>(
      r'id == $0',
      [id],
    ).firstOrNull;
  }

  @override
  Stream<double> getStockStream({int? productId, int? variantId}) async* {
    while (true) {
      double totalStock = 0.0;
      if (productId != null) {
        final query = realm!.query<Stock>(
          r'productId == $0',
          [productId],
        );
        totalStock = query.fold<double>(
            0.0, (sum, stock) => sum + stock.currentStock.toDouble());
      } else if (variantId != null) {
        final query = realm!.query<Stock>(
          r'variantId == $0',
          [variantId],
        );
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
      final stocks = realm!.query<Stock>(
        r'branchId == $0',
        [branchId],
      );
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.value));
      yield totalStock;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Future<Tenant?> getTenantBYPin({required int pin}) async {
    return realm!.query<Tenant>(
      r'pin == $0 AND isDefault $1',
      [pin, true],
    ).firstOrNull;
  }

  @override
  Future<Tenant?> getTenantBYUserId({required int userId}) async {
    return realm!.query<Tenant>(
      r'userId == $0',
      [userId],
    ).firstOrNull;
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> getTransactionById({required int id}) async {
    return realm!.query<ITransaction>(
      r'id == $0',
      [id],
    ).firstOrNull;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) async {
    return realm!.query<TransactionItem>(
      r'id == $0',
      [id],
    ).firstOrNull;
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId}) async {
    return realm!.query<TransactionItem>(
      r'variantId == $0 AND transactionId == $1 AND deletedAt == nil',
      [variantId, transactionId],
    ).firstOrNull;
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) async {
    return realm!.query<TransactionItem>(
      r'transactionId == $0 AND deletedAt == nil',
      [transactionId],
    ).toList();
  }

  @override
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required int customerId}) async* {
    final controller = StreamController<List<ITransaction>>.broadcast();

    final query = realm!.query<ITransaction>(
      r'customerId == $0 AND deletedAt == nil',
      [customerId],
    );

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
    return realm!.query<Variant>(
      r'id == $0 AND deletedAt == nil',
      [id],
    ).firstOrNull;
  }

  @override
  Future<List<Variant>> getVariantByProductId({int? productId}) async {
    return realm!.query<Variant>(
      r'productId == $0 AND deletedAt == nil',
      [productId],
    ).toList();
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    final controller = StreamController<List<Variant>>.broadcast();

    final query = realm!.query<Variant>(
      r'productId == $0 AND deletedAt == nil',
      [productId],
    );

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
          r'cashierId == $0 AND deletedAt == nil',
          [cashierId],
        ).firstOrNull !=
        null;
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled() {
    return true;
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
  Future<void> loadCounterFromOnline({required int businessId}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/counter/$businessId"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      List<ICounter> counters = ICounter.fromJsonList(jsonResponse);

      /// first check if we don't have local counter that we are overwriting
      List<Counter> localCounters =
          realm!.query<Counter>(r'businessId == $0', [businessId]).toList();
      if (localCounters.isNotEmpty) return;
      for (ICounter counter in counters) {
        realm!.write(() {
          realm!.put<Counter>(Counter(
            ObjectId(),
            id: counter.id,
            branchId: counter.branchId,
            businessId: counter.businessId,
            totRcptNo: counter.totRcptNo,
            curRcptNo: counter.curRcptNo,
            receiptType: counter.receiptType,
          ));
        });
      }
    } else {
      throw InternalServerError(term: "Error loading the counters");
    }
  }

  @override
  Future<void> logOut() async {
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
    await firebase.FirebaseAuth.instance.currentUser?.getIdToken(true);
  }

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
      final transaction = ITransaction(
        ObjectId(),
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
        createdAt: DateTime.now().toIso8601String(),
      );

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
      final transaction = ITransaction(
        ObjectId(),
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
        createdAt: DateTime.now().toIso8601String(),
      );

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
  Future<Drawers?> openDrawer({required Drawers drawer}) async {
    int id = randomNumber();
    realm!.write(() {
      realm!.put<Drawers>(drawer..id = id);
    });
    return realm!.query<Drawers>(
      r'id == $0 AND deletedAt == nil',
      [id],
    ).firstOrNull;
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    final controller = StreamController<List<ITransaction>>.broadcast();

    final query = realm!.query<ITransaction>(
      r'status == $0 AND supplierId == $1 AND deletedAt == nil',
      [PENDING, branchId],
    );

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
  Future<void> patchSocialSetting({required Setting setting}) async {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType}) async {
    return realm!.query<ITransaction>(
      r'branchId == $0 AND transactionType == $1 AND deletedAt == nil',
      [branchId, transactionType],
    ).firstOrNull;
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    final controller = StreamController<List<Product>>.broadcast();
    int branchId = ProxyService.box.getBranchId()!;
    RealmResults<Product> query;
    if (prodIndex == null) {
      query = realm!.query<Product>(
        r'branchId == $0  AND deletedAt == nil',
        [branchId],
      );
    } else {
      query = realm!.query<Product>(
        r'branchId == $0 AND id == $1 AND deletedAt == nil',
        [branchId, prodIndex],
      );
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
      r'branchId == $0  AND deletedAt == nil',
      [branchId],
    ).toList();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) async {
    // Fetch all products based on branch ID and additional criteria
    final date = DateTime.now().subtract(const Duration(days: 7));
    List<Product> allProducts = realm!.query<Product>(
      r'branchId == $0 && deletedAt == nil && lastTouched > $1',
      [branchId, date],
    ).toList();

    // if we have no recent product please load without the condition
    if (allProducts.isEmpty) {
      allProducts = realm!.query<Product>(
        r'branchId == $0 && deletedAt == nil',
        [branchId],
      ).toList();
    }

    // Limit to the last 7 items
    List<Product> filteredProducts;

    if (allProducts.length >= 7) {
      filteredProducts = allProducts
          .sublist(allProducts.length - 7)
          .where((product) =>
              product.name != TEMP_PRODUCT && product.name != CUSTOM_PRODUCT)
          .toList();
    } else {
      filteredProducts = allProducts
          .where((product) =>
              product.name != TEMP_PRODUCT && product.name != CUSTOM_PRODUCT)
          .toList();
    }

    // Return the filtered list of products
    return filteredProducts;
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
  Future<List<ITenant>> signup({required Map business}) async {
    talker.info(business.toString());
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/business"),
      body: jsonEncode(business),
    );
    if (response.statusCode == 200) {
      /// because we want to close the inMemory realm db
      /// as soon as possible so I can be able to save real data into realm
      /// then I call login in here after signup as login handle configuring
      await login(
          userPhone: business['phoneNumber'], skipDefaultAppSetup: true);
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;

        Tenant iTenant = Tenant(ObjectId(),
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        final businessToAdd = <Business>[];
        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(
            ObjectId(),
            id: business.id,
            userId: business.userId,
            name: business.name,
            currency: business.currency,
            categoryId: business.categoryId,
            latitude: business.latitude,
            longitude: business.longitude,
            timeZone: business.timeZone,
            country: business.country,
            businessUrl: business.businessUrl,
            hexColor: business.hexColor,
            imageUrl: business.imageUrl,
            type: business.type,
            active: business.active,
            chatUid: business.chatUid,
            metadata: business.metadata,
            role: business.role,
            lastSeen: business.lastSeen,
            firstName: business.firstName,
            lastName: business.lastName,
            createdAt: business.createdAt,
            deviceToken: business.deviceToken,
            backUpEnabled: business.backUpEnabled,
            subscriptionPlan: business.subscriptionPlan,
            nextBillingDate: business.nextBillingDate,
            previousBillingDate: business.previousBillingDate,
            isLastSubscriptionPaymentSucceeded:
                business.isLastSubscriptionPaymentSucceeded,
            backupFileId: business.backupFileId,
            email: business.email,
            lastDbBackup: business.lastDbBackup,
            fullName: business.fullName,
            tinNumber: business.tinNumber,
            bhfId: business.bhfId,
            dvcSrlNo: business.dvcSrlNo,
            adrs: business.adrs,
            taxEnabled: business.taxEnabled,
            taxServerUrl: business.taxServerUrl,
            isDefault: business.isDefault,
            businessTypeId: business.businessTypeId,
            lastTouched: business.lastTouched,
            action: business.action,
            deletedAt: business.deletedAt,
            encryptionKey: business.encryptionKey,
          );
          businessToAdd.add(biz);
        }
        realm!.write(() {
          realm!.addAll<Business>(businessToAdd);
        });
        final branchToAdd = <Branch>[];
        for (IBranch brannch in jTenant.branches) {
          Branch branch = Branch(
            ObjectId(),
            id: brannch.id,
            active: brannch.active,
            description: brannch.description,
            name: brannch.name,
            businessId: brannch.businessId,
            longitude: brannch.longitude,
            latitude: brannch.latitude,
            isDefault: brannch.isDefault,
            lastTouched: brannch.lastTouched,
            action: brannch.action,
            deletedAt: brannch.deletedAt,
          );
          branchToAdd.add(branch);
        }
        realm!.write(() {
          realm!.addAll<Branch>(branchToAdd);
        });
        realm!.write(() {
          for (IPermission permission in jTenant.permissions) {
            realm!.put<LPermission>(LPermission(
              ObjectId(),
              id: permission.id,
              name: permission.name,
            ));
          }
        });
        tenantToAdd.add(iTenant);
      }
      realm!.write(() {
        realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    } else {
      throw InternalServerError(term: response.body.toString());
    }
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
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
  Future<List<Tenant>> tenants({int? businessId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;
        Tenant iTenant = Tenant(ObjectId(),
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        realm!.write(() {
          for (IBusiness business in jTenant.businesses) {
            Business biz = Business(
              ObjectId(),
              id: business.id,
              userId: business.userId,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey,
            );
            Business? exist =
                realm!.query<Business>(r'id == $0', [business.id]).firstOrNull;
            if (exist == null) {
              realm!.put<Business>(biz);
            }
          }
        });
        realm!.write(() {
          for (IBranch brannch in jTenant.branches) {
            Branch branch = Branch(
              ObjectId(),
              id: brannch.id,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt,
            );
            Branch? exist =
                realm!.query<Branch>(r'id == $0', [branch.id]).firstOrNull;
            if (exist == null) {
              realm!.put<Branch>(branch);
            }
          }
        });
        final permissionToAdd = <LPermission>[];
        for (IPermission permission in jTenant.permissions) {
          LPermission? exist = realm!
              .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
          if (exist == null) {
            final perm = LPermission(
              ObjectId(),
              id: permission.id,
              name: permission.name,
            );
            permissionToAdd.add(perm);
          }
        }

        realm!.write(() {
          realm!.addAll<LPermission>(permissionToAdd);
        });

        tenantToAdd.add(iTenant);
      }
      realm!.write(() {
        realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<List<ITransaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
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

    final query = realm!.query<ITransaction>(
      queryString,
      [
        PARKED,
        branchId,
      ],
    );
    StreamController<List<ITransaction>>? controller;
    controller = StreamController<List<ITransaction>>.broadcast(
      onListen: () {
        final initialResults = query.toList();
        controller!.sink.add(initialResults.toList());

        query.changes.listen((results) {
          controller!.sink.add(results.results.toList());
        });
      },
      onCancel: () {
        query.unsubscribe();
        controller!.close();
      },
    );

    return controller.stream;
  }

  @override
  Future<List<TransactionItem>> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) async {
    int branchId = ProxyService.box.getBranchId()!;
    String queryString = "";

    queryString = r'''deletedAt = nil
        && doneWithTransaction == $0
        && (
          branchId ==$1 && active == $2 && transactionId == $3
        )
    ''';

    return realm!.query<TransactionItem>(
      queryString,
      [doneWithTransaction, branchId, active, transactionId],
    ).toList();
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
      bool includePending = false}) async {
    String queryString = "";
    if (isCashOut) {
      queryString = r'''deletedAt = nil
        && status == $0
        && (
          transactionType IN ANY {'cashOut'} && branchId == $1
        )
    ''';
    } else {
      queryString = r'''deletedAt = nil
        && status == $0
        && (
          transactionType IN ANY {'cashIn', 'sale', 'custom', 'onlineSale'} && branchId == $1
        )
    ''';
    }
    return realm!.query<ITransaction>(
      queryString,
      [
        status ?? 'COMPLETE',
        branchId,
      ],
    ).toList();
  }

  @override
  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
  }) {
    String queryString = "";
    if (isCashOut) {
      queryString = r'''deletedAt = nil
        && status == $0
        && (
          transactionType IN ANY {'cashOut'} && branchId == $1
        )
    ''';
    } else {
      queryString = r'''deletedAt = nil
        && status == $0
        && (
          transactionType IN ANY {'cashIn', 'sale', 'custom', 'onlineSale'} && branchId == $1
        )
    ''';
    }
    final query = realm!.query<ITransaction>(
      queryString,
      [
        status ?? 'COMPLETE',
        branchId,
      ],
    );
    StreamController<List<ITransaction>>? controller;
    controller = StreamController<List<ITransaction>>.broadcast(
      onListen: () {
        final initialResults = query.toList();
        controller!.sink.add(initialResults.toList());

        query.changes.listen((results) {
          controller!.sink.add(results.results.toList());
        });
      },
      onCancel: () {
        query.unsubscribe();
        controller!.close();
      },
    );

    return controller.stream;
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
  Future<int> update<T>({required T data, bool localUpdate = false}) async {
    /// update user activity
    int userId = ProxyService.box.getUserId() ?? 0;
    if (userId == 0) return 0;

    if (data is Device) {
      Device device = data;

      realm!.write(() {
        if (localUpdate) {
          realm!.add<Device>(device, update: true);
        } else {
          realm!.add<Device>(device, update: true);
        }
      });
    }

    if (data is Product) {
      Product product = data;
      product.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      realm!.write(() {
        if (localUpdate) {
          realm!.add<Product>(product, update: true);
        } else {
          realm!.add<Product>(product, update: true);
        }
      });
    }
    if (data is Favorite) {
      Favorite fav = data;
      realm!.write(() {
        if (localUpdate) {
          realm!.add<Favorite>(fav, update: true);
        } else {
          realm!.add<Favorite>(fav, update: true);
        }
      });
    }
    if (data is Variant) {
      Variant variant = data;
      variant.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      realm!.write(() {
        if (localUpdate) {
          realm!.add<Variant>(variant, update: true);
        } else {
          realm!.add<Variant>(variant, update: true);
        }
      });
    }
    if (data is Stock) {
      Stock stock = data;
      stock.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      realm!.write(() {
        if (localUpdate) {
          realm!.add<Stock>(stock, update: true);
        } else {
          realm!.add<Stock>(stock, update: true);
        }
      });
    }
    if (data is ITransaction) {
      final transaction = data;
      transaction.lastTouched =
          DateTime.now().toLocal().add(Duration(hours: 2));
      realm!.write(() {
        if (localUpdate) {
          realm!.add<ITransaction>(transaction, update: true);
        } else {
          realm!.add<ITransaction>(transaction, update: true);
        }
      });
    }
    if (data is Category) {
      final category = data;
      realm!.write(() {
        if (localUpdate) {
          realm!.add<Category>(category, update: true);
        } else {
          realm!.add<Category>(category, update: true);
        }
      });
    }
    if (data is IUnit) {
      final unit = data;
      realm!.write(() {
        if (localUpdate) {
          realm!.add<IUnit>(unit, update: true);
        } else {
          realm!.add<IUnit>(unit, update: true);
        }
      });
    }
    if (data is PColor) {
      final color = data;
      realm!.write(() {
        if (localUpdate) {
          realm!.add<PColor>(color, update: true);
        } else {
          realm!.add<PColor>(color, update: true);
        }
      });
    }
    if (data is TransactionItem) {
      data.lastTouched = DateTime.now().toLocal();
      realm!.write(() {
        if (localUpdate) {
          realm!.add<TransactionItem>(data, update: true);
        } else {
          realm!.add<TransactionItem>(data, update: true);
        }
      });
    }
    if (data is EBM) {
      final ebm = data;
      realm!.write(() {
        ProxyService.box
            .writeString(key: "serverUrl", value: ebm.taxServerUrl ?? 'null');

        Business? business =
            realm!.query<Business>(r'userId == $0', [ebm.userId]).first;

        business
          ..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        if (localUpdate) {
          realm!.add<Business>(business, update: true);
        } else {
          realm!.add<Business>(business, update: true);
        }
      });
    }
    if (data is Token) {
      final token = data;
      token
        ..token = token.token
        ..businessId = token.businessId
        ..type = token.type;
      realm!.write(() {
        if (localUpdate) {
          realm!.add<Token>(token);
        } else {
          realm!.add<Token>(token);
        }
      });
    }
    if (data is Business) {
      final business = data;
      realm!.write(() {
        realm!.add<Business>(business);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/business/${business.id}"),
        body: jsonEncode(business.toEJson()),
      );
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the business");
      }
    }

    if (data is Branch) {
      realm!.write(() {
        realm!.add<Branch>(data);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/branch/${data.id}"),
        body: jsonEncode(data.toEJson()),
      );
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the branch");
      }
    }
    if (data is Counter) {
      Counter? iCounter = realm!.query<Counter>(
          r'receiptType == $0', [data.receiptType!.toUpperCase()]).firstOrNull;
      if (iCounter != null) {
        iCounter.totRcptNo = data.totRcptNo;
        iCounter.curRcptNo = data.curRcptNo;
        realm!.write(() {
          realm!.add<Counter>(iCounter);
        });
      } else {
        realm!.write(() {
          realm!.add<Counter>(data);
        });
      }
    }
    if (data is Branch) {
      realm!.write(() {
        realm!.add<Branch>(data);
      });
      try {
        await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/branch/${data.id}"),
          body: jsonEncode(data.toEJson()),
        );
      } catch (e) {}
    }
    if (data is Drawers) {
      final drawer = data;

      realm!.write(() {
        realm!.add<Drawers>(drawer);
      });
    }
    if (data is User) {
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/user"),
        body: jsonEncode(data.toEJson()),
      );
      return response.statusCode;
    }
    if (data is Tenant) {
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/tenant/${data.id}"),
        body: jsonEncode(data.toEJson()),
      );
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

  Future<String> absolutePath(String fileName) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final int businessId = ProxyService.box.getBusinessId() ?? 0;
    final int branchId = ProxyService.box.getBranchId() ?? 0;
    final realmDirectory = '${appDocsDirectory.path}/flipper-v2-' +
        branchId.toString() +
        "_" +
        businessId.toString();

    // Create the new directory
    await Directory(realmDirectory).create(recursive: true);

    return "$realmDirectory/$fileName";
  }

  @override
  Future<RealmApiInterface> configure({required bool inTesting}) async {
    if (foundation.kDebugMode && !isAndroid) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else if (foundation.kDebugMode && isAndroid) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else if (!foundation.kDebugMode) {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }

    Configuration config;

    if (inTesting) {
      if (realm != null) {
        realm!.close();
      }
      config = Configuration.inMemory(realmModels);
      realm = Realm(config);
    } else if (ProxyService.box.getBranchId() != null ||
        ProxyService.box.getBusinessId() != null) {
      /// because most likely we will open the realm with sync after we opened in memory database
      /// then we need to close the one recently opened
      if (realm != null) {
        realm!.close();
      }
      talker.info("opening the synced realm for the app to run on launch");

      // List<int> key = ProxyService.box.encryptionKey().toIntList();
      String path = await absolutePath("db_");
      //NOTE: https://www.mongodb.com/docs/atlas/app-services/domain-migration/
      final app = App(AppConfiguration(AppSecrets.appId,
          baseUrl: Uri.parse("https://services.cloud.mongodb.com")));
      final user = app.currentUser ??
          await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));

      int? branchId = ProxyService.box.getBranchId() ?? 0;
      int? businessId = ProxyService.box.getBusinessId() ?? 0;
      config = Configuration.flexibleSync(
        user,
        realmModels,
        encryptionKey: ProxyService.box.encryptionKey().toIntList(),
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
      try {
        if (await ProxyService.status.isInternetAvailable()) {
          talker.info("Opened realm[1] with  internet access!");
          realm = await Realm.open(config, cancellationToken: token,
              onProgressCallback: (syncProgress) {
            if (syncProgress.progressEstimate == 1.0) {
              talker.info('All bytes transferred!');
            }
          });
        } else {
          talker.info("Opened realm[1] with no internet access!");
          realm = Realm(config);
        }
      } catch (e) {
        talker.info("Opened realm in catch ");
        realm = Realm(config);
      }
      // Realm.logger.level = RealmLogLevel.trace;
      await updateSubscription(branchId, businessId);

      /// removed await on bellow line because when it is in bootstrap, it might freeze the app
      await realm?.subscriptions.waitForSynchronization();
    } else {
      //  open local database not synced one!
      talker.info(
          "opening the inMemory realm for the app to run on launch this is case where we don't have configuration necessary from the authenticated user!");
      final config = Configuration.inMemory(realmModels);
      realm = Realm(config);
    }
    return this;
  }

  Future<void> updateSubscription(int? branchId, int? businessId) async {
    if (realm == null) return;
    //https://www.mongodb.com/docs/realm/sdk/flutter/sync/manage-sync-subscriptions/
    final transactionItem =
        realm!.query<TransactionItem>(r'branchId == $0', [branchId]);
    final product = realm!.query<Product>(r'branchId == $0', [branchId]);
    final variant = realm!.query<Variant>(r'branchId == $0', [branchId]);
    final stock = realm!.query<Stock>(r'branchId == $0', [branchId]);
    final unit = realm!.query<IUnit>(r'branchId == $0', [branchId]);
    final counter = realm!.query<Counter>(r'branchId == $0', [branchId]);
    final receipt = realm!.query<Receipt>(r'branchId == $0', [branchId]);
    final customer = realm!.query<Customer>(r'branchId == $0', [branchId]);
    final category = realm!.query<Customer>(r'branchId == $0', [branchId]);
    final branch = realm!.query<Branch>(r'businessId == $0', [businessId]);
    final colors = realm!.query<PColor>(r'id == $0', [branchId]);
    final devices = realm!.query<Device>(r'branchId == $0', [branchId]);

    final business = realm!.query<Business>(r'id == $0', [businessId]);
    final transaction =
        realm!.query<ITransaction>(r'branchId == $0', [branchId]);

    final conversations =
        realm!.query<Conversation>(r'businessId == $0', [businessId]);

    //TODO need to add branchId to know the drawer so we can open drawer for whole branch not for user
    // final drawers = realm!.query<Drawers>(r'cashierId == $0', [ProxyService.box.getUserId()]);

    final ebms = realm!.query<EBM>(r'businessId == $0', [businessId]);

    final favorites = realm!.query<Favorite>(r'branchId == $0', [branchId]);

    final receipts = realm!.query<Receipt>(r'branchId == $0', [branchId]);
    final units = realm!.query<IUnit>(r'branchId == $0', [branchId]);
    final permission = realm!
        .query<LPermission>(r'userId == $0', [ProxyService.box.getUserId()!]);

    final pin = realm!.query<Pin>(
        r'userId == $0', [ProxyService.box.getUserId()?.toString()]);

    // fake subscription as I normally do not these model synced accros devices but I don't know how I can pause one model
    final token = realm!.query<Token>(r'businessId == $0', [businessId]);
    final tenant =
        realm!.query<Tenant>(r'userId == $0', [ProxyService.box.getUserId()]);

    await token.subscribe(
        name: "token-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);
    // end of fake subs

    // https://stackoverflow.com/questions/66565463/disable-realm-sync-only-for-non-premium-users

    await tenant.subscribe(
        name: "tenant-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await permission.subscribe(
        name: "permission-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await pin.subscribe(
        name: "pin-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await units.subscribe(
        name: "units-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await receipts.subscribe(
        name: "favorites-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await favorites.subscribe(
        name: "favorites-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await ebms.subscribe(
        name: "ebms-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);
    await devices.subscribe(
        name: "devices-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await conversations.subscribe(
        name: "conversations-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await colors.subscribe(
        name: "colors-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await category.subscribe(
        name: "category-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await business.subscribe(
        name: "business-${businessId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await branch.subscribe(
        name: "branch-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);
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

  void _processVariant(int branchId, Variant variation) {
    int stockId = randomNumber();
    Variant? variant = realm!.query<Variant>(
        r'id == $0 && branchId == $1 && deletedAt == nil',
        [variation.id, branchId]).firstOrNull;
    if (variant != null) {
      Stock? stock = realm!.query<Stock>(
          r'id == $0 &&  branchId == $1 && deletedAt == nil',
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
        realm!.write(() => realm!.put<Stock>(newStock));
      }
      stock!.currentStock = stock.currentStock + variation.qty;

      /// rsdQty is the remaining stock that is not yet sold bas
      stock.rsdQty = stock.currentStock + variation.qty;

      log(variation.qty.toString(), name: 'Incoming updated quantity');

      stock.action = AppActions.updated;
      stock.lastTouched = DateTime.now().toLocal();
      stock.value = (variation.qty * (variation.retailPrice)).toDouble();
      realm!.write(() => realm!.put<Stock>(stock));

      variant.qty = variation.qty;
      variant.retailPrice = variation.retailPrice;
      variant.supplyPrice = variation.supplyPrice;

      variant.action = AppActions.updated;
      variant.lastTouched = DateTime.now().toLocal();
      realm!.write(() => realm!.put<Variant>(variant));
    } else {
      int variationId = randomNumber();
      int stockId = randomNumber();

      variation.pkg = "1";
      variation.id = variationId;
      variation.action = AppActions.created;
      variation.retailPrice = variation.retailPrice;
      variation.supplyPrice = variation.supplyPrice;
      realm!.write(() => realm!.put<Variant>(variation));
      final newStock = Stock(
        ObjectId(),
        id: stockId,
        lastTouched: DateTime.now(),
        branchId: branchId,
        variantId: variationId,
        action: AppActions.created,
        retailPrice: variation.retailPrice,
        supplyPrice: variation.supplyPrice,
        currentStock: variation.qty,
        value: (variation.qty * (variation.retailPrice)).toDouble(),
        productId: variation.productId,
      )..active = true;

      realm!.write(() => realm!.put<Stock>(newStock));
    }
  }

  Variant _createRegularVariant(
      Product product, int branchId, Business? business) {
    final int variantId = randomNumber();
    return Variant(
      ObjectId(),
      lastTouched: DateTime.now(),
      name: 'Regular',
      sku: 'sku',
      action: 'create',
      productId: product.id!,
      color: product.color,
      unit: 'Per Item',
      productName: product.name,
      branchId: branchId,
      supplyPrice: 0.0,
      retailPrice: 0.0,
      id: variantId,
      isTaxExempted: false,
      bhfId: business?.bhfId ?? '00',
      itemStdNm: "Regular",
      addInfo: "A",
      pkg: "1",
      itemSeq: "1",
      splyAmt: 0.0,
    );
  }

  _findProductByBusinessId({required String name, required int businessId}) {
    return realm!.query<Product>(
      r'businessId == $0 ',
      [businessId],
    ).firstOrNull;
  }

  Future<Variant?> _addMissingVariant(
      Variant? variant, Product? product, int branchId) async {
    Business? business = await getBusiness();

    try {
      if (variant == null) {
        int variantId = randomNumber();
        String clip = 'flipper' +
            DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

        realm!.write(() {
          realm!.put<Variant>(
            Variant(ObjectId(),
                id: variantId,
                lastTouched: DateTime.now(),
                name: 'Custom Amount',
                color: product!.color,
                sku: 'sku',
                action: 'create',
                productId: product.id!,
                unit: 'Per Item',
                productName: product.name,
                branchId: ProxyService.box.getBranchId()!,
                supplyPrice: 0.0,
                retailPrice: 0.0,
                itemCd: clip,
                bhfId: business.bhfId ?? '',
                isTaxExempted: false)
              ..name = 'Regular'
              ..productId = product.id!
              ..unit = 'Per Item'
              ..productName = product.name
              ..branchId = branchId
              ..taxName = 'N/A'
              ..isTaxExempted = false
              ..taxPercentage = 0
              ..retailPrice = 0
              // RRA fields
              // ... (populate RRA fields using a separate function)
              ..supplyPrice = 0.0,
          );
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
          realm!.put<Stock>(stock);
        });
        return realm!.query<Variant>(
          r'id == $0 ',
          [variantId],
        ).firstOrNull;
      }
    } catch (error) {
      // Handle error during write operation
      throw Exception("unknown");
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
    return realm!.query<LPermission>(
      r'userId == $0 ',
      [userId],
    ).firstOrNull;
  }

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false}) async {
    talker.info(userPhone);
    String phoneNumber = userPhone;

    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }
    http.Response response;
    String? uid = firebase.FirebaseAuth.instance.currentUser?.uid ?? null;

    response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body: jsonEncode(
        <String, String?>{'phoneNumber': phoneNumber, 'uid': uid},
      ),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Create an IUser object using the fromJson constructor
      IUser user = IUser.fromJson(jsonResponse);
      await _configureTheBox(userPhone, user);

      /// after we login this is the best time to open the synced database to start persisting the data
      await configure(inTesting: false);
      if (stopAfterConfigure) return user;
      if (skipDefaultAppSetup == false) {
        await ProxyService.box.writeString(
          key: 'defaultApp',

          /// because we don update default app from server
          /// because we want the ability of switching apps to be entirely offline
          /// then if we have a default app in the box we use it if it only different from "1"
          value: user.tenants.isEmpty
              ? 'null'
              : ProxyService.box.getDefaultApp() != "1"
                  ? ProxyService.box.getDefaultApp()
                  : user.tenants.first.businesses.first.businessTypeId
                      .toString(),
        );
      }

      for (ITenant tenant in user.tenants) {
        Tenant iTenant = Tenant(ObjectId(),
            isDefault: tenant.isDefault,
            id: tenant.id,
            name: tenant.name,
            businessId: tenant.businessId,
            nfcEnabled: tenant.nfcEnabled,
            email: tenant.email,
            userId: user.id!,
            phoneNumber: tenant.phoneNumber,
            pin: tenant.pin);
        final businessesToAdd = <Business>[];
        final branchToAdd = <Branch>[];

        for (IBusiness business in tenant.businesses) {
          Business biz = Business(
            ObjectId(),
            id: business.id,
            userId: business.userId,
            name: business.name,
            currency: business.currency,
            categoryId: business.categoryId,
            latitude: business.latitude,
            longitude: business.longitude,
            timeZone: business.timeZone,
            country: business.country,
            businessUrl: business.businessUrl,
            hexColor: business.hexColor,
            imageUrl: business.imageUrl,
            type: business.type,
            active: business.active,
            chatUid: business.chatUid,
            metadata: business.metadata,
            role: business.role,
            lastSeen: business.lastSeen,
            firstName: business.firstName,
            lastName: business.lastName,
            createdAt: business.createdAt,
            deviceToken: business.deviceToken,
            backUpEnabled: business.backUpEnabled,
            subscriptionPlan: business.subscriptionPlan,
            nextBillingDate: business.nextBillingDate,
            previousBillingDate: business.previousBillingDate,
            isLastSubscriptionPaymentSucceeded:
                business.isLastSubscriptionPaymentSucceeded,
            backupFileId: business.backupFileId,
            email: business.email,
            lastDbBackup: business.lastDbBackup,
            fullName: business.fullName,
            tinNumber: business.tinNumber,
            bhfId: business.bhfId,
            dvcSrlNo: business.dvcSrlNo,
            adrs: business.adrs,
            taxEnabled: business.taxEnabled,
            taxServerUrl: business.taxServerUrl,
            isDefault: business.isDefault,
            businessTypeId: business.businessTypeId,
            lastTouched: business.lastTouched,
            action: business.action,
            deletedAt: business.deletedAt,
            encryptionKey: business.encryptionKey,
          );
          Business? exist =
              realm!.query<Business>(r'id == $0', [business.id]).firstOrNull;
          if (exist == null) {
            businessesToAdd.add(biz);
          }
        }
        realm!.writeAsync(() {
          realm!.addAll<Business>(businessesToAdd);
        });
        for (IBranch brannch in tenant.branches) {
          Branch branch = Branch(
            ObjectId(),
            id: brannch.id,
            active: brannch.active,
            description: brannch.description,
            name: brannch.name,
            businessId: brannch.businessId,
            longitude: brannch.longitude,
            latitude: brannch.latitude,
            isDefault: brannch.isDefault,
            lastTouched: brannch.lastTouched,
            action: brannch.action,
            deletedAt: brannch.deletedAt,
          );
          Branch? exist =
              realm!.query<Branch>(r'id == $0', [branch.id]).firstOrNull;
          if (exist == null) {
            branchToAdd.add(branch);
          }
        }

        realm!.write(() {
          realm!.addAll<Branch>(branchToAdd);
        });
        final permissionToAdd = <LPermission>[];
        for (IPermission permission in tenant.permissions) {
          LPermission? exist = realm!
              .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
          if (exist == null) {
            final perm = LPermission(
              ObjectId(),
              id: permission.id,
              name: permission.name,
            );
            permissionToAdd.add(perm);
          }
        }
        realm!.write(() {
          realm!.addAll<LPermission>(permissionToAdd);
        });

        Tenant? exist =
            realm!.query<Tenant>(r'id == $0', [iTenant.id]).firstOrNull;
        if (exist == null) {
          realm!.write(() {
            if (user.id == iTenant.userId) {
              iTenant.sessionActive = true;
              realm!.put<Tenant>(iTenant);
            } else {
              realm!.put<Tenant>(iTenant);
            }
          });
        }
      }

      return user;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      log(response.body.toString(), name: "login error");
      throw Exception(response.body.toString());
    }
  }

  Future<void> _configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(
      key: 'userPhone',
      value: userPhone,
    );
    await ProxyService.box.writeString(
      key: 'bearerToken',
      value: user.token,
    );

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(
      key: 'uid',
      value: user.uid,
    );
    await ProxyService.box.writeInt(
      key: 'userId',
      value: user.id!,
    );

    if (user.tenants.isEmpty) {
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    if (user.tenants.first.businesses.isEmpty ||
        user.tenants.first.branches.isEmpty) {
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    await ProxyService.box.writeInt(
      key: 'branchId',
      value: user.tenants.isEmpty ? 0 : user.tenants.first.branches.first.id!,
    );

    talker.info("UserId:" + user.id.toString());
    await ProxyService.box.writeInt(
      key: 'businessId',
      value: user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id!,
    );
    await ProxyService.box.writeString(
      key: 'encryptionKey',
      value: user.tenants.first.businesses.first.encryptionKey,
    );
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": "1", "typeName": "Flipper Retailer"},
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
}
