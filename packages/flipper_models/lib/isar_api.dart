// import 'dart:async';
// import 'package:flipper_models/flipper_http_client.dart';
// import 'package:flipper_models/isolateHandelr.dart';
// import 'package:flipper_models/mocks.dart';
// import 'package:flipper_models/models.dart';
// import 'package:flipper_models/secrets.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart' as firebase;
// import 'package:flipper_models/isar/random.dart';
// import 'package:flipper_models/isar/receipt_signature.dart';
// import 'package:flipper_services/app_service.dart';
// import 'package:flipper_services/constants.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:flipper_models/realm_model_export.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:flipper_services/locator.dart' as loc;
// import 'package:flutter/foundation.dart' as foundation;
// import 'package:talker_flutter/talker_flutter.dart';
// import 'extensions/isar_extension.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flipper_routing/receipt_types.dart';

// class IsarAPI<M> with IsolateHandler implements IsarApiInterface {
//   FlipperHttpClient flipperHttpClient = FlipperHttpClient(http.Client());
//   late String apihub;
//   late String commApi;
//   late Isar isar;
//   final talker = TalkerFlutter.init();
//   Future<String> absolutePath(String fileName) async {
//     final appDocsDirectory = await getApplicationDocumentsDirectory();
//     final realmDirectory = '${appDocsDirectory.path}/${fileName}';

//     // Create the new directory
//     await Directory(realmDirectory).create(recursive: true);

//     return realmDirectory;
//   }

//   Future<IsarApiInterface> getInstance({Isar? isa}) async {
//     String? appDocDir = '';

//     if (foundation.kDebugMode && !isAndroid) {
//       apihub = AppSecrets.apihubUat;
//       commApi = AppSecrets.commApi;
//     } else if (foundation.kDebugMode && isAndroid) {
//       apihub = AppSecrets.apihubUat;
//       commApi = AppSecrets.commApi;
//     } else if (!foundation.kDebugMode) {
//       apihub = AppSecrets.apihubProd;
//       commApi = AppSecrets.commApi;
//     }
//     if (isa == null) {
//       appDocDir = await absolutePath("v3");

//       isar = await Isar.open(
//         // compactOnLaunch:
//         //     CompactCondition(minBytes: 100, minFileSize: 100, minRatio: 2.0),
//         models,
//         directory: appDocDir,
//         name: 'default',
//         // encryptionKey: "flipper-0123456789",
//       );
//     } else {
//       isar = isa;
//     }
//     return this;
//   }

//   /// Adds a new customer to the database and associates them with the given transaction.
//   ///
//   /// @param customer - The Customer object to add.
//   /// @param transactionId - The ID of the transaction to associate the customer with.
//   /// @returns The added Customer object.
//   @override
//   Future<Customer?> addCustomer(
//       {required Customer customer, required int transactionId}) async {
//     try {
//       // Add the customer to the database
//       isar.writeTxn(() async {
//         isar.customers.onPut(customer);
//       });

//       // Get the transaction from the database
//       final ITransaction? transaction =
//           await isar.iTransactions.get(transactionId);

//       if (transaction != null) {
//         // Update the transaction with the customer ID
//         transaction.customerId = customer.id;
//         await update(data: transaction);
//       }

//       return customer;
//     } catch (e) {
//       print('Failed to add customer: $e');
//       throw e;
//     }
//   }

//   /// this method is one way i.e we get to know local unsynched changes
//   /// then we send them but we are not working on the changes after this push.
//   /// those change will stay on local, so I need to work on them as well.

//   @override
//   Future<ITransaction> manageTransaction(
//       {required String transactionType}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     ITransaction? existTransaction = await pendingTransaction(
//         branchId: branchId, transactionType: transactionType);
//     if (existTransaction == null) {
//       final int id = randomNumber();
//       final transaction = ITransaction(
//         lastTouched: DateTime.now(),
//         id: id,
//         reference: randomNumber().toString(),
//         action: AppActions.created,
//         transactionNumber: randomNumber().toString(),
//         status: PENDING,
//         transactionType: transactionType,
//         subTotal: 0,
//         cashReceived: 0,
//         updatedAt: DateTime.now().toIso8601String(),
//         customerChangeDue: 0.0,
//         paymentType: 'Cash',
//         branchId: branchId,
//         createdAt: DateTime.now().toIso8601String(),
//       );

//       // save transaction to isar
//       isar.writeTxn(() async {
//         isar.iTransactions.onPut(transaction);
//       });
//       ITransaction? createdTransaction = await isar.iTransactions.get(id);
//       ProxyService.box.writeInt(key: 'currentTransactionId', value: id);
//       return createdTransaction!;
//     } else {
//       return existTransaction;
//     }
//   }

//   @override
//   Future<ITransaction> manageCashInOutTransaction(
//       {required String transactionType}) async {
//     int branchId = ProxyService.box.getBranchId()!;

//     ITransaction? existTransaction = await pendingTransaction(
//         branchId: branchId, transactionType: transactionType);

//     int businessId = ProxyService.box.getBusinessId()!;
//     if (existTransaction == null) {
//       int id = randomNumber();
//       final transaction = ITransaction(
//         lastTouched: DateTime.now(),
//         id: id,
//         supplierId: businessId,
//         reference: randomNumber().toString(),
//         action: AppActions.created,
//         transactionNumber: randomNumber().toString(),
//         status: PENDING,
//         transactionType: transactionType,
//         subTotal: 0,
//         cashReceived: 0,
//         updatedAt: DateTime.now().toIso8601String(),
//         customerChangeDue: 0.0,
//         paymentType: 'Cash',
//         branchId: branchId,
//         createdAt: DateTime.now().toIso8601String(),
//       );

//       // save transaction to isar
//       isar.writeTxn(() async {
//         isar.iTransactions.onPut(transaction);
//       });
//       ITransaction? createdTransaction = await isar.iTransactions.get(id);
//       ProxyService.box.writeInt(key: 'currentTransactionId', value: id);
//       return createdTransaction!;
//     } else {
//       return existTransaction;
//     }
//   }

//   @override
//   Future<void> addTransactionItem(
//       {required ITransaction transaction,
//       required TransactionItem item}) async {
//     talker.info(item.toJson());
//     isar.writeTxnSync(() {
//       final id = isar.transactionItems.putSync(item);
//       talker.info("SavedIDDD ${id}");
//     });
//   }

//   // get point where userId = userId from isar
//   @override
//   Future<Pointss> addPoint({required int userId, required int point}) async {
//     final pointss =
//         await isar.pointss.filter().userIdEqualTo(userId).findFirst();
//     if (pointss == null) {
//       throw Exception('Pointss not found for user ID: $userId');
//     }
//     return pointss;
//   }

//   @override
//   Future<ITransaction?> getTransactionById({required int id}) async {
//     int branchId = ProxyService.box.getBranchId()!;

//     // Use 'await' to unwrap the Future and get the ITransaction? instance
//     ITransaction? transaction = await isar.iTransactions
//         .filter()
//         .idEqualTo(id)
//         .and()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();

//     // Return the unwrapped result
//     return transaction;
//   }

//   //Delete a favorite
//   @override
//   Future<int> deleteTransactionByIndex({required int transactionIndex}) async {
//     isar.writeTxn(() async {
//       isar.iTransactions.delete(transactionIndex);
//     });
//     return Future.value(200);
//   }

//   /// Sums the total income and expense amounts from transactions within a given time period.
//   ///
//   /// The `period` parameter specifies the time period to filter transactions by. Valid values are:
//   /// - 'Today' - Transactions from today
//   /// - 'This Week' - Transactions from the last 7 days
//   /// - 'This Month' - Transactions from the last 30 days
//   /// - 'This Year' - Transactions from the last 365 days
//   ///
//   /// Returns a map with the total `income` and `expense` amounts.
//   @override
//   Future<({double income, double expense})> getTransactionsAmountsSum(
//       {required String period}) async {
//     DateTime oldDate;
//     DateTime temporaryDate;

//     if (period == 'Today') {
//       DateTime tempToday = DateTime.now();
//       oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
//     } else if (period == 'This Week') {
//       oldDate = DateTime.now().subtract(Duration(days: 7));
//     } else if (period == 'This Month') {
//       oldDate = DateTime.now().subtract(Duration(days: 30));
//     } else {
//       oldDate = DateTime.now().subtract(Duration(days: 365));
//     }

//     List<ITransaction> transactions = await transactionsFuture();

//     List<ITransaction> filteredTransactions = [];
//     for (final transaction in transactions) {
//       temporaryDate = DateTime.parse(transaction.createdAt);
//       if (temporaryDate.isAfter(oldDate)) {
//         filteredTransactions.add(transaction);
//       }
//     }

//     double sum_cash_in = 0;
//     double sum_cash_out = 0;
//     for (final transaction in filteredTransactions) {
//       if (transaction.transactionType == 'Cash Out') {
//         sum_cash_out = transaction.subTotal + sum_cash_out;
//       } else {
//         sum_cash_in = transaction.subTotal + sum_cash_in;
//       }
//     }

//     return (income: sum_cash_in, expense: sum_cash_out);
//   }

//   @override
//   Future<int> addFavorite({required Favorite data}) async {
//     Favorite? fav = await isar.favorites
//         .filter()
//         .favIndexEqualTo(data.favIndex!)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//     if (fav == null) {
//       data.id = randomNumber();
//       isar.writeTxn(() async {
//         isar.favorites.put(data);
//       });
//       return Future.value(200);
//     } else {
//       fav.productId = data.productId;
//       isar.writeTxn(() async {
//         isar.favorites.onPut(fav);
//       });
//       return Future.value(200);
//     }
//   }

//   @override
//   Future<List<Favorite>> getFavorites() async {
//     List<Favorite> favorites =
//         await isar.favorites.filter().deletedAtIsNull().findAll();
//     return favorites;
//   }

//   @override
//   Future<Favorite?> getFavoriteById({required int favId}) async {
//     //Get a favorite
//     Favorite? favorite = await isar.favorites
//         .filter()
//         .idEqualTo(favId)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//     return favorite;
//   }

//   @override
//   Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
//     //Get a favorite
//     Favorite? favorite = await isar.favorites
//         .filter()
//         .favIndexEqualTo(favIndex)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//     return favorite;
//   }

//   @override
//   Future<Product?> getProduct({required int id}) async {
//     return await isar.products
//         .filter()
//         .idEqualTo(id)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//   }

//   @override
//   Future<Favorite?> getFavoriteByProdId({required int prodId}) async {
//     Favorite? favorite = await isar.favorites
//         .filter()
//         .productIdEqualTo(prodId)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//     return favorite;
//   }

//   //Delete a favorite
//   @override
//   Future<int> deleteFavoriteByIndex({required int favIndex}) async {
//     isar.writeTxn(() async {
//       isar.favorites
//           .filter()
//           .favIndexEqualTo(favIndex)
//           .and()
//           .deletedAtIsNull()
//           .deleteFirst();
//     });
//     return Future.value(200);
//   }

//   @override
//   Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     isar.writeTxn(() async {
//       for (Map map in units) {
//         final unit = IUnit(
//             active: map['active'],
//             branchId: branchId,
//             id: randomNumber(),
//             name: map['name'],
//             action: AppActions.created,
//             lastTouched: DateTime.now(),
//             value: map['value']);

//         // save unit to isar
//         isar.iUnits.onPut(unit);
//       }
//     });
//     return Future.value(200);
//   }

//   @override
//   Future<int> addVariant({required List<Variant> variations}) async {
//     int branchId = ProxyService.box.getBranchId()!;

//     await Future.wait(
//         variations.map((variation) => _processVariant(branchId, variation)));

//     return 200;
//   }

//   Future<void> _processVariant(
//     int branchId,
//     Variant variation,
//   ) async {
//     int stockId = randomNumber();
//     Variant? variant = await isar.variants
//         .filter()
//         .idEqualTo(variation.id)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();

//     if (variant != null) {
//       Stock? stock = await isar.stocks
//           .filter()
//           .variantIdEqualTo(variation.id!)
//           .and()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .findFirst();

//       if (stock == null) {
//         final newStock = Stock(
//           id: stockId,
//           lastTouched: DateTime.now(),
//           branchId: branchId,
//           variantId: variation.id!,
//           action: AppActions.created,
//           retailPrice: variation.retailPrice,
//           supplyPrice: variation.supplyPrice,
//           currentStock: variation.qty!,
//           rsdQty: variation.qty,
//           value: variation.qty! * variation.retailPrice,
//           productId: variation.productId,
//         )..active = false;

//         isar.writeTxn(() async => isar.stocks.onPut(newStock));
//       }

//       stock!.currentStock = stock.currentStock + variation.qty!;

//       /// rsdQty is the remaining stock that is not yet sold bas
//       stock.rsdQty = stock.currentStock + variation.qty!;

//       log(variation.qty!.toString(), name: 'Incoming updated quantity');

//       stock.action = AppActions.updated;
//       stock.lastTouched = DateTime.now().toLocal();
//       stock.value = variation.qty! * variation.retailPrice;
//       isar.writeTxn(() async => isar.stocks.onPut(stock));

//       variant.qty = variation.qty!;
//       variant.retailPrice = variation.retailPrice;
//       variant.supplyPrice = variation.supplyPrice;

//       variant.action = AppActions.updated;
//       variant.lastTouched = DateTime.now().toLocal();

//       isar.writeTxn(() async => isar.variants.onPut(variant));
//     } else {
//       int variationId = randomNumber();
//       int stockId = randomNumber();

//       variation.pkg = "1";
//       variation.id = variationId;
//       variation.action = AppActions.created;
//       variation.retailPrice = variation.retailPrice;
//       variation.supplyPrice = variation.supplyPrice;
//       isar.writeTxn(() async => isar.variants.onPut(variation));

//       final newStock = Stock(
//         id: stockId,
//         lastTouched: DateTime.now(),
//         branchId: branchId,
//         variantId: variationId,
//         action: AppActions.created,
//         retailPrice: variation.retailPrice,
//         supplyPrice: variation.supplyPrice,
//         currentStock: variation.qty!,
//         value: variation.qty! * variation.retailPrice,
//         productId: variation.productId,
//       )..active = true;

//       isar.writeTxn(() async => isar.stocks.onPut(newStock));
//     }
//   }

//   // get list of IBusiness from isar where userId = userId
//   // if list is empty then get list from online
//   @override
//   Future<List<IBusiness>> businesses({int? userId}) async {
//     List<IBusiness> businesses = [];
//     if (userId != null) {
//       businesses =
//           await isar.iBusiness.filter().userIdEqualTo(userId).findAll();
//     } else {
//       businesses = await isar.iBusiness.filter().deletedAtIsNull().findAll();
//     }

//     return businesses;
//   }

//   @override
//   Future<List<IBranch>> branches({int? businessId}) async {
//     // if in local isar we have no branch fetch it from online
//     if (businessId != null) {
//       return await isar.iBranchs
//           .filter()
//           .businessIdEqualTo(businessId)
//           .findAll();
//     } else {
//       return await isar.iBranchs.filter().deletedAtIsNull().findAll();
//     }
//   }

//   @override
//   Future<bool> checkIn({required String? checkInCode}) async {
//     //  String? checkIn = ProxyService.box.read(key: 'checkIn');

//     final businessName = checkInCode!.split('-')[0];
//     final businessId = int.parse(checkInCode.split('-')[1]);
//     final submitTo = checkInCode.split('-')[2];

//     // get the profile from store
//     // Profile? profile = store.box<Profile>().get(1);
//     Profile? profile;
//     //then send the data to api
//     DateTime _now = DateTime.now();

//     /// add flag for checkin as early as possible because we might get so many scan result
//     /// or the user might scann for too long which can result into multiple checkin
//     /// to avoid that we add a flag to checkin then if we fail we remove it to enable next check in attempt
//     // ProxyService.box.write(key: 'checkIn', value: 'checkIn');
//     final http.Response response = await flipperHttpClient.post(
//       Uri.parse("$apihub/v2/api/attendance"),
//       body: jsonEncode({
//         "businessId": businessId,
//         "businessName": businessName,
//         "fullName": profile!.name,
//         "phoneNumber": profile.phone,
//         "checkInDate": DateTime.now().toIso8601String(),
//         "checkInTime":
//             '${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}',
//         "vaccinationCode": profile.vaccinationCode,
//         "livingAt": profile.livingAt,
//         "cell": profile.cell,
//         "district": profile.district,
//         "submitTo": submitTo
//       }),
//     );
//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override

//   /// Collects the payment for a transaction, updates the transaction status, calculates the customer change due, and updates the transaction and related items in the database.
//   ///
//   /// This method is responsible for the following tasks:
//   /// - Sets the transaction status to `COMPLETE`
//   /// - Retrieves the transaction items that are not yet done with the transaction
//   /// - Calculates the sub-total of the transaction items
//   /// - Sets the customer change due, payment type, and cash received on the transaction
//   /// - Determines the receipt type based on the app's mode (normal, proforma, or training)
//   /// - Updates the transaction's `updatedAt` and `createdAt` timestamps
//   /// - Updates the stock quantities and values for the transaction items
//   /// - Marks the transaction items as done with the transaction
//   /// - Updates the `lastTouched` timestamp for the related product
//   /// - Removes the `currentTransactionId` from the local storage
//   ///
//   /// @param cashReceived The amount of cash received from the customer
//   /// @param transaction The transaction object to be updated
//   /// @param paymentType The type of payment (e.g., cash, card)
//   Future<void> collectPayment(
//       {required double cashReceived,
//       required ITransaction transaction,
//       required String paymentType}) async {
//     transaction.status = COMPLETE;

//     List<TransactionItem> items = await transactionItems(
//         transactionId: transaction.id!,
//         doneWithTransaction: false,
//         active: true);
//     double subTotal = items.fold(0, (num a, b) => a + (b.price * b.qty));
//     transaction.customerChangeDue = (cashReceived - subTotal);
//     transaction.paymentType = paymentType;
//     transaction.cashReceived = cashReceived;
//     transaction.subTotal = subTotal;

//     /// for now receipt type to be printed is in box shared preference
//     /// this ofcause has limitation that if more than two users are using device
//     /// one user will use configuration set by probably a different user, this need to change soon.
//     String receiptType = "ns";
//     if (ProxyService.box.isPoroformaMode()) {
//       receiptType = ReceiptType.ps;
//     }
//     if (ProxyService.box.isTrainingMode()) {
//       receiptType = ReceiptType.ts;
//     }
//     transaction.receiptType = receiptType;

//     /// refresh created as well to reflect when this transaction was created and completed

//     transaction.updatedAt = DateTime.now().toIso8601String();
//     transaction.createdAt = DateTime.now().toIso8601String();
//     log(DateTime.now().toLocal().add(Duration(hours: 2)).toString(),
//         name: "LocalDate");
//     transaction.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));

//     await update(data: transaction);

//     for (TransactionItem item in items) {
//       Stock? stock = await stockByVariantId(variantId: item.variantId);
//       stock!.currentStock = stock.currentStock - item.qty;
//       // stock value after item deduct
//       stock.value = stock.currentStock * (stock.retailPrice ?? 0.0);
//       stock.action = AppActions.updated;
//       item.doneWithTransaction = true;
//       item.updatedAt = DateTime.now().toIso8601String();
//       await update(data: stock);
//       await update(data: item);
//       // search the related product and touch them to make them as most used
//       Variant? variant = await getVariantById(id: item.variantId);
//       Product? product = await getProduct(id: variant?.productId ?? 0);
//       if (product != null) {
//         product.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
//         await update(data: product);
//       }
//     }
//     // remove currentTransactionId from local storage to leave a room
//     // for listening to new transaction that will be created
//     ProxyService.box.remove(key: 'currentTransactionId');
//   }

//   @override
//   Future<List<PColor>> colors({required int branchId}) async {
//     return await isar.pColors
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   @override
//   void consumePoints({required int userId, required int points}) async {
//     // Retrieve user's points from the database
//     Pointss? userPoints =
//         await isar.pointss.filter().userIdEqualTo(userId).findFirst();

//     // Deduct the consumed points from the user's total points
//     userPoints!.value -= points;

//     // Update the modified points back to the database
//     isar.writeTxn(() async {
//       isar.pointss.put(userPoints);
//     });
//   }

//   @override
//   Future<Voucher?> consumeVoucher({required int voucherCode}) async {
//     final http.Response response = await flipperHttpClient.patch(
//       Uri.parse("$apihub/v2/api/voucher"),
//       body: jsonEncode(
//         <String, int>{'id': voucherCode},
//       ),
//     );
//     if (response.statusCode == 422) return null;
//     return Voucher(id: randomNumber())
//       ..createdAt = json.decode(response.body)['createdAt']
//       ..usedAt = json.decode(response.body)['usedAt']
//       ..descriptor = json.decode(response.body)['descriptor']
//       ..interval = json.decode(response.body)['interval']
//       ..value = json.decode(response.body)['value'];
//   }

//   @override
//   Future<void> createGoogleSheetDoc({required String email}) async {
//     // TODOre-work on this until it work 100%;
//     IBusiness business = await getBusiness();
//     String docName = business!.name! + '- Report';

//     await flipperHttpClient.post(
//       Uri.parse("$apihub/v2/api/createSheetDocument"),
//       body: jsonEncode({"title": docName, "shareToEmail": email}),
//     );
//   }

//   @override
//   Future<Pin?> createPin() async {
//     String id = ProxyService.box.getUserId()!.toString();
//     //get existing pin where userId =1
//     // if pin is null then create new pin
//     Pin? pin = await isar.pins.filter().userIdEqualTo(id).findFirst();
//     if (pin != null) {
//       return pin;
//     }

//     int branchId = ProxyService.box.getBranchId()!;
//     int businessId = ProxyService.box.getBusinessId()!;
//     String phoneNumber = ProxyService.box.getUserPhone()!;
//     String defaultApp = ProxyService.box.getDefaultApp();
//     final http.Response response = await flipperHttpClient.post(
//       Uri.parse("$apihub/v2/api/pin"),
//       body: jsonEncode(
//         <String, dynamic>{
//           'userId': id,
//           'branchId': branchId.toString(),
//           'businessId': businessId.toString(),
//           'phoneNumber': phoneNumber,
//           'pin': id,
//           'defaultApp': defaultApp
//         },
//       ),
//     );
//     if (response.statusCode == 200) {
//       int id = randomNumber();
//       Pin pin = Pin.fromJson(json.decode(response.body));
//       pin.id = id;
//       isar.writeTxn(() async {
//         isar.pins.put(pin);
//       });
//       return isar.pins.get(id);
//     }
//     return null;
//   }

//   @override
//   Future<Product?> createProduct(
//       {required Product product, bool skipRegularVariant = false}) async {
//     final IBusiness business = await getBusiness();
//     final int branchId = ProxyService.box.getBranchId()!;
//     final int businessId = ProxyService.box.getBusinessId()!;

//     // Check if the product created (custom or temp) already exists and return it
//     final String productName = product.name;
//     if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
//       final Product? existingProduct = await _findProductByNameAnisarusinessId(
//         name: productName,
//         businessId: businessId,
//       );
//       if (existingProduct != null) {
//         return existingProduct;
//       }
//     }

//     isar.writeTxn(() async {
//       isar.products.onPut(product);

//       if (!skipRegularVariant) {
//         final Product? kProduct = await isar.products.get(product.id!);

//         // Create a Regular Variant
//         final Variant newVariant =
//             _createRegularVariant(product, branchId, business);
//         isar.variants.onPut(newVariant);

//         // Create a Stock for the Regular Variant
//         final Stock stock = Stock(
//           lastTouched: DateTime.now(),
//           id: randomNumber(),
//           action: 'create',
//           branchId: branchId,
//           variantId: newVariant.id!,
//           currentStock: 0.0,
//           productId: kProduct!.id!,
//         );
//         isar.stocks.onPut(stock);
//       }
//     });

//     return await isar.products.get(product.id!);
//   }

//   Variant _createRegularVariant(
//       Product product, int branchId, IBusiness business) {
//     final int variantId = randomNumber();
//     return Variant(
//       lastTouched: DateTime.now(),
//       name: 'Regular',
//       sku: 'sku',
//       action: 'create',
//       productId: product.id!,
//       color: product.color,
//       unit: 'Per Item',
//       productName: product.name,
//       branchId: branchId,
//       supplyPrice: 0.0,
//       retailPrice: 0.0,
//       id: variantId,
//       isTaxExempted: false,
//       bhfId: business?.bhfId ?? '00',
//       itemStdNm: "Regular",
//       addInfo: "A",
//       pkg: "1",
//       itemSeq: "1",
//       splyAmt: 0.0,
//     );
//   }

//   Future<Product?> _findProductByNameAnisarusinessId({
//     required String name,
//     required int businessId,
//   }) async {
//     return await isar.products
//         .filter()
//         .nameEqualTo(name)
//         .and()
//         .businessIdEqualTo(businessId)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//   }

//   @override
//   bool isTaxEnabled() {
//     ///TODO: to simplify testing
//     ///for now manually enable ebm by default, this will enable us
//     ///to fast test the ebm integration with no friction!
//     return true;
//     // IBusiness business = await getBusiness();
//     // bool isEbmEnabled = business?.tinNumber != null &&
//     //     business?.bhfId != null &&
//     //     business?.dvcSrlNo != null &&
//     //     business?.taxEnabled == true;
//     // return Future.value(isEbmEnabled);
//   }

//   @override
//   Future<Setting?> createSetting({required Setting setting}) {
//     // TODO: implement createSetting
//     throw UnimplementedError();
//   }

//   @override
//   Future<bool> delete({required int id, String? endPoint}) async {
//     final DateTime deletionTime = DateTime.now();

//     switch (endPoint) {
//       case 'color':
//         isar.writeTxn(() async {
//           PColor? color = await isar.pColors.get(id);
//           if (color != null) {
//             color.deletedAt = deletionTime;
//             color.action = AppActions.deleted;
//             isar.pColors.onPut(color);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'device':
//         isar.writeTxn(() async {
//           Device? device = await isar.devices.get(id);
//           if (device != null) {
//             device.deletedAt = deletionTime;
//             device.action = AppActions.deleted;
//             isar.devices.onPut(device);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'category':
//         isar.writeTxn(() async {
//           Category? category = await isar.categorys.get(id);
//           if (category != null) {
//             category.deletedAt = deletionTime;
//             category.action = AppActions.deleted;
//             isar.categorys.onPut(category);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'product':
//         isar.writeTxn(() async {
//           Product? product = await isar.products.get(id);
//           if (product != null) {
//             product.deletedAt = deletionTime;
//             product.action = AppActions.deleted;
//             isar.products.onPut(product);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'variant':
//         isar.writeTxn(() async {
//           Variant? variant = await isar.variants.get(id);
//           if (variant != null) {
//             variant.deletedAt = deletionTime;
//             variant.action = AppActions.deleted;
//             isar.variants.onPut(variant);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'stock':
//         isar.writeTxn(() async {
//           Stock? stocks = await isar.stocks.get(id);
//           if (stocks != null) {
//             stocks.deletedAt = deletionTime;
//             stocks.action = AppActions.deleted;
//             isar.stocks.onPut(stocks);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'setting':
//         isar.writeTxn(() async {
//           Setting? setting = await isar.settings.get(id);
//           if (setting != null) {
//             setting.deletedAt = deletionTime;
//             setting.action = AppActions.deleted;
//             isar.settings.onPut(setting);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'pin':
//         isar.writeTxn(() async {
//           Pin? pin = await isar.pins.get(id);
//           if (pin != null) {
//             isar.pins.delete(pin.id!);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'business':
//         isar.writeTxn(() async {
//           isar.iBusiness.delete(id);
//         });
//         break;
//       case 'branch':
//         isar.writeTxn(() async {
//           isar.iBranchs.delete(id);
//           return true;
//         });
//         break;

//       case 'voucher':
//         isar.writeTxn(() async {
//           isar.vouchers.delete(id);
//           return true;
//         });
//         break;
//       case 'transactionItem':
//         isar.writeTxn(() async {
//           TransactionItem? transactionItems =
//               await isar.transactionItems.get(id);
//           if (transactionItems != null) {
//             transactionItems.deletedAt = deletionTime;
//             transactionItems.action = AppActions.deleted;
//             isar.transactionItems.onPut(transactionItems);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'customer':
//         isar.writeTxn(() async {
//           Customer? customer = await isar.customers.get(id);
//           if (customer != null) {
//             customer.deletedAt = deletionTime;
//             customer.action = AppActions.deleted;
//             isar.customers.onPut(customer);
//             return true;
//           }
//           return false;
//         });
//         break;
//       case 'tenant':
//         final response = await flipperHttpClient.delete(
//           Uri.parse("$apihub/v2/api/tenant/${id}"),
//         );
//         if (response.statusCode == 200) {
//           isar.writeTxn(() async {
//             isar.iITenants.delete(id);
//             return true;
//           });
//         }
//         break;
//       default:
//         return Future.value(false);
//     }
//     return Future.value(false);
//   }

//   @override
//   void emptySentMessageQueue() {
//     // TODO: implement emptySentMessageQueue
//   }

//   @override
//   Future<bool> enableAttendance(
//       {required int businessId, required String email}) async {
//     /// call to create attendance document
//     /// get business from store

//     IBusiness business = await isar.iBusiness.get(businessId);
//     final http.Response response = await flipperHttpClient.post(
//       Uri.parse("$apihub/v2/api/createAttendanceDoc"),
//       body: jsonEncode({
//         "title": business!.name! + '-' + 'Attendance',
//         "shareToEmail": email
//       }),
//     );
//     if (response.statusCode == 200) {
//       // update settings with enableAttendance = true
//       int businessId = ProxyService.box.getBusinessId()!;
//       Setting? setting = await getSetting(businessId: businessId);
//       setting!.attendnaceDocCreated = true;
//       update(data: setting);
//       return true;
//     }

//     return false;
//   }

//   @override
//   Future<IBusiness> getBusiness({int? businessId}) async {
//     if (businessId != null) {
//       return await isar.iBusiness.get(businessId);
//     } else {
//       ///FIXME: what will happen if a user has multiple business associated to him
//       ///the code bellow suggest that the first in row will be returned which can be wrong.
//       int? userId = ProxyService.box.getUserId();
//       return await isar.iBusiness.filter().userIdEqualTo(userId).findFirst();
//     }
//   }

//   @override
//   Future<IBusiness> getBusinessFromOnlineGivenId({required int id}) async {
//     IBusiness business =
//         await isar.iBusiness.filter().idEqualTo(id).findFirst();
//     if (business != null) return business;
//     final http.Response response =
//         await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
//     if (response.statusCode == 200) {
//       int id = randomNumber();
//       IBusiness business = IBusiness.fromJson(json.decode(response.body));
//       // TODO: check if in incoming object we have an id
//       business.id = id;
//       isar.writeTxn(() async {
//         isar.iBusiness.put(business);
//       });
//       return isar.iBusiness.get(id);
//     }
//     return null;
//   }

//   @override
//   Future<PColor?> getColor({required int id}) async {
//     return await isar.pColors.get(id);
//   }

//   @override
//   Future<List<IBusiness>> getContacts() {
//     // TODO: implement getContacts
//     throw UnimplementedError();
//   }

//   @override
//   Future<Variant?> getCustomVariant() async {
//     final branchId = ProxyService.box.getBranchId()!;
//     final businessId = ProxyService.box.getBusinessId()!;

//     // Find product with name CUSTOM_PRODUCT
//     Product? product =
//         await isar.products.filter().nameEqualTo(CUSTOM_PRODUCT).findFirst();

//     if (product == null) {
//       // Create a new custom product if it doesn't exist
//       product = await createProduct(
//         product: Product(
//           id: randomNumber(),
//           lastTouched: DateTime.now(),
//           name: CUSTOM_PRODUCT,
//           action: 'create',
//           businessId: businessId,
//           color: "#e74c3c",
//           createdAt: DateTime.now().toIso8601String(),
//           branchId: businessId,
//         ),
//       );
//     }

//     // Find variant associated with the custom product
//     Variant? variant =
//         await isar.variants.filter().productIdEqualTo(product!.id!).findFirst();

//     if (variant == null) {
//       // If the variant doesn't exist, add it
//       variant = await addMissingVariant(
//         variant,
//         product,
//         branchId,
//       );
//     }

//     return variant;
//   }

//   Future<Variant?> addMissingVariant(
//       Variant? variation, Product product, int branchId) async {
//     if (variation == null) {
//       int variantId = randomNumber();
//       // add variant to this product
//       IBusiness business = await getBusiness();
//       String clip = 'flipper' +
//           DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

//       isar.writeTxn(() async {
//         await isar.variants.onPut(
//           Variant(
//               id: variantId,
//               lastTouched: DateTime.now(),
//               name: 'Custom Amount',
//               color: product.color,
//               sku: 'sku',
//               action: 'create',
//               productId: product.id!,
//               unit: 'Per Item',
//               productName: product.name,
//               branchId: ProxyService.box.getBranchId()!,
//               supplyPrice: 0.0,
//               retailPrice: 0.0,
//               itemCd: clip,
//               bhfId: business?.bhfId ?? '',
//               isTaxExempted: false)
//             ..name = 'Regular'
//             ..productId = product.id!
//             ..unit = 'Per Item'
//             ..productName = product.name
//             ..branchId = branchId
//             ..taxName = 'N/A'
//             ..isTaxExempted = false
//             ..taxPercentage = 0
//             ..retailPrice = 0
//             // RRA fields

//             ..prc = 0.0
//             ..sku = 'sku'
//             ..tin = business?.tinNumber
//             ..itemCd = clip
//             // TODOask about item clasification code, it seems to be static
//             ..itemClsCd = "5020230602"
//             ..itemTyCd = "1"
//             ..itemNm = "Regular"
//             ..itemStdNm = "Regular"
//             ..orgnNatCd = "RW"
//             ..pkgUnitCd = "NT"
//             ..qtyUnitCd = "U"
//             ..taxTyCd = "B"
//             ..dftPrc = 0.0
//             ..addInfo = "A"
//             ..isrcAplcbYn = "N"
//             ..useYn = "N"
//             ..regrId = clip
//             ..regrNm = "Regular"
//             ..modrId = clip
//             ..modrNm = "Regular"
//             ..pkg = "1"
//             ..itemSeq = "1"
//             ..splyAmt = 0.0
//             // RRA fields ends
//             ..supplyPrice = 0.0,
//         );
//         Stock stock = Stock(
//             lastTouched: DateTime.now(),
//             id: randomNumber(),
//             action: 'create',
//             branchId: branchId,
//             variantId: variantId,
//             currentStock: 0.0,
//             productId: product.id!)
//           ..canTrackingStock = false
//           ..showLowStockAlert = false
//           ..currentStock = 0.0
//           ..branchId = branchId
//           ..variantId = variantId
//           ..supplyPrice = 0.0
//           ..retailPrice = 0.0
//           ..lowStock = 10.0 // default static
//           ..canTrackingStock = true
//           ..showLowStockAlert = true
//           ..active = false
//           ..productId = product.id!
//           ..rsdQty = 0.0;
//         await isar.stocks.onPut(stock);
//       });
//       return await isar.variants.get(variantId);
//     }
//     return variation;
//   }

//   @override
//   Future<List<Discount>> getDiscounts({required int branchId}) async {
//     return await isar.discounts.filter().branchIdEqualTo(branchId).findAll();
//   }

//   @override
//   Future<IBusiness> getOnlineBusiness({required int userId}) async {
//     final response = await flipperHttpClient
//         .get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

//     if (response.statusCode == 401) {
//       throw SessionException(term: "session expired");
//     }
//     if (response.statusCode == 404) {
//       throw BusinessNotFoundException(term: "IBusiness not found");
//     }

//     IBusiness business = await isar.iBusiness
//         .get(IBusiness.fromJson(json.decode(response.body)).id!);

//     if (business == null) {
//       isar.writeTxn(() async {
//         isar.iBusiness.put(IBusiness.fromJson(json.decode(response.body)));
//       });
//       business =
//           await isar.iBusiness.filter().userIdEqualTo(userId).findFirst();
//     }
//     ProxyService.box.writeInt(key: 'businessId', value: business!.id!);

//     return business;
//   }

//   @override
//   Future<TransactionItem?> getTransactionItemById({required int id}) async {
//     return await isar.transactionItems
//         .filter()
//         .idEqualTo(id)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//   }

//   @override
//   Future<TransactionItem?> getTransactionItemByVariantId(
//       {required int variantId, required int? transactionId}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     return isar.transactionItems
//         .filter()
//         .variantIdEqualTo(variantId)
//         .and()
//         .transactionIdEqualTo(transactionId!)
//         .and()
//         .deletedAtIsNull()
//         .and()
//         .branchIdEqualTo(branchId)
//         .findFirst();
//   }

//   @override
//   Future<List<TransactionItem>> getTransactionItemsByTransactionId(
//       {required int? transactionId}) async {
//     return isar.transactionItems
//         .filter()
//         .transactionIdEqualTo(transactionId!)
//         .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   /// since tennat has userId which is a pin, we need to think if
//   /// we still need to create & get pin
//   @override
//   Future<Pin?> getPin({required String pin}) async {
//     final Uri uri = Uri.parse("$apihub/v2/api/pin/$pin");

//     try {
//       final http.Response response = await http.get(uri);

//       if (response.statusCode == 200) {
//         return Pin.fromJson(json.decode(response.body));
//       } else if (response.statusCode == 404) {
//         throw ErrorReadingFromYBServer(term: response.body);
//       } else {
//         throw ErrorReadingFromYBServer(term: response.body);
//       }
//     } catch (error) {
//       throw ErrorReadingFromYBServer(term: error.toString());
//     }
//   }

//   @override
//   Future<Pointss?> getPoints({required int userId}) async {
//     return isar.pointss.filter().userIdEqualTo(userId).findFirst();
//   }

//   @override
//   Future<Setting?> getSetting({required int businessId}) async {
//     return isar.writeTxn(() async {
//       return isar.settings.filter().businessIdEqualTo(businessId).findFirst();
//     });
//   }

//   @override
//   Future<Stock?> getStock(
//       {required int branchId, required int variantId}) async {
//     return isar.stocks
//         .filter()
//         .variantIdEqualTo(variantId)
//         .and()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//   }

//   @override
//   Future<Subscription?> getSubscription({required int userId}) async {
//     Subscription? local =
//         await isar.subscriptions.filter().userIdEqualTo(userId).findFirst();
//     if (local == null) {
//       final response = await flipperHttpClient
//           .get(Uri.parse("$apihub/v2/api/subscription/$userId"));
//       if (response.statusCode == 200) {
//         Subscription? sub = Subscription.fromJson(json.decode(response.body));

//         isar.writeTxn(() async {
//           isar.subscriptions.put(sub);
//         });
//         return sub;
//       } else {
//         return null;
//       }
//     } else {
//       return local;
//     }
//   }

//   @override
//   bool isSubscribed({required String feature, required int businessId}) {
//     // TODO: implement isSubscribed
//     throw UnimplementedError();
//   }

//   @override
//   int lifeTimeCustomersForbranch({required String branchId}) {
//     // TODO: implement lifeTimeCustomersForbranch
//     throw UnimplementedError();
//   }

//   @override
//   void clear() {
//     isar.writeTxn(() async {
//       isar.products.clear();
//       isar.variants.clear();
//       isar.stocks.clear();
//       isar.iTransactions.clear();
//       isar.transactionItems.clear();
//     });
//   }

//   @override
//   Future<void> logOut() async {
//     // delete all business and branches from isar isar for
//     // potential next business that can log-in to not mix data.

//     await firebase.FirebaseAuth.instance.signOut();

//     ///logout the realm and delete realm file
//     // await ProxyService.realm.logout();
//     isar.writeTxn(() async {
//       isar.iBusiness.clear();
//       isar.iBranchs.clear();
//       isar.iITenants.clear();
//       isar.iPermissions.clear();
//       isar.userActivitys.clear();
//       isar.pins.clear();
//     });
//     if (ProxyService.box.getUserId() != null &&
//         ProxyService.box.getBusinessId() != null) {
//       ProxyService.event.publish(loginDetails: {
//         'channel': "${ProxyService.box.getUserId()!}-logout",
//         'userId': ProxyService.box.getUserId()!,
//         'businessId': ProxyService.box.getBusinessId()!,
//         'branchId': ProxyService.box.getBranchId()!,
//         'phone': ProxyService.box.getUserPhone(),
//         'defaultApp': ProxyService.box.getDefaultApp(),
//         'deviceName': Platform.operatingSystem,
//         'deviceVersion': Platform.operatingSystemVersion,
//         'linkingCode': randomNumber().toString()
//       });
//     }
//     // for box clearing if we are using box then we need to be explicit
//     // of the keys
//     ProxyService.box.remove(key: 'userId');
//     ProxyService.box.remove(key: 'getIsTokenRegistered');
//     ProxyService.box.remove(key: 'bearerToken');
//     ProxyService.box.remove(key: 'branchId');
//     ProxyService.box.remove(key: 'userPhone');
//     ProxyService.box.remove(key: 'UToken');
//     ProxyService.box.remove(key: 'businessId');
//     ProxyService.box.remove(key: 'defaultApp');
//     ProxyService.box.remove(key: 'authComplete');
//     // but for shared preference we can just clear them all
//     ProxyService.box.clear();

//     //https://github.com/firebase/flutterfire/issues/2185
//     await firebase.FirebaseAuth.instance.currentUser?.getIdToken(true);
//   }

//   @override
  // Future<ITenant> saveTenant(String phoneNumber, String name,
  //     {required IBusiness business,
  //     required IBranch branch,
  //     required String userType}) async {
  //   final http.Response response = await flipperHttpClient.post(
  //     Uri.parse("$apihub/v2/api/tenant"),
  //     body: jsonEncode({
  //       "phoneNumber": phoneNumber,
  //       "name": name,
  //       "businessId": business.id,
  //       "permissions": [
  //         {"name": userType.toLowerCase()}
  //       ],
  //       "businesses": [business.toJson()],
  //       "branches": [branch.toJson()]
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     ITenant jTenant = ITenant.fromRawJson(response.body);
  //     IITenant iTenant = IITenant(
  //         isDefault: jTenant.isDefault,
  //         id: randomNumber(),
  //         name: jTenant.name,
  //         businessId: jTenant.businessId,
  //         email: jTenant.email,
  //         userId: jTenant.userId,
  //         nfcEnabled: jTenant.nfcEnabled,
  //         phoneNumber: jTenant.phoneNumber);

  //     isar.writeTxn(() async {
  //       for (var business in jTenant.businesses) {
  //         // Check if the business with the same ID already exists
  //         var existingBusiness =
  //             await isar.iBusiness.filter().idEqualTo(business.id).findFirst();
  //         if (existingBusiness == null) {
  //           isar.iBusiness.put(business);
  //         }
  //       }

  //       for (var branch in jTenant.branches) {
  //         // Check if the branch with the same ID already exists
  //         var existingBranch =
  //             await isar.iBranchs.filter().idEqualTo(branch.id).findFirst();
  //         if (existingBranch == null) {
  //           isar.iBranchs.put(branch);
  //         }
  //       }

  //       for (var permission in jTenant.permissions) {
  //         // Check if the permission with the same ID already exists
  //         var existingPermission = await isar.iPermissions
  //             .filter()
  //             .idEqualTo(permission.id)
  //             .findFirst();
  //         if (existingPermission == null) {
  //           // Permission doesn't exist, add it
  //           isar.iPermissions.put(permission);
  //         }
  //       }
  //     });

  //     isar.writeTxn(() async {
  //       var tenant =
  //           await isar.iITenants.filter().idEqualTo(iTenant.id).findFirst();
  //       if (tenant == null) {
  //         isar.iITenants.put(iTenant);
  //       }
  //     });

  //     return ITenant.fromRawJson(response.body);
  //   } else {
  //     throw InternalServerError(term: "internal server error");
  //   }
  // }

//   @override
//   Future<List<ITenant>> signup({required Map business}) async {
//     log(business.toString(), name: "Signup");
//     final http.Response response = await flipperHttpClient.post(
//       Uri.parse("$apihub/v2/api/business"),
//       body: jsonEncode(business),
//     );
//     if (response.statusCode == 200) {
//       for (ITenant tenant in ITenant.fromJsonList(response.body)) {
//         ITenant jTenant = tenant;
//         IITenant iTenant = IITenant(
//             isDefault: jTenant.isDefault,
//             id: jTenant.id,
//             name: jTenant.name,
//             userId: jTenant.userId,
//             businessId: jTenant.businessId,
//             nfcEnabled: jTenant.nfcEnabled,
//             email: jTenant.email,
//             phoneNumber: jTenant.phoneNumber);

//         isar.writeTxn(() async {
//           isar.iBusiness.putAll(jTenant.businesses);
//         });
//         isar.writeTxn(() async {
//           isar.iBranchs.putAll(jTenant.branches);
//         });
//         isar.writeTxn(() async {
//           isar.iPermissions.putAll(jTenant.permissions);
//         });
//         isar.writeTxn(() async {
//           isar.iITenants.put(iTenant);
//         });
//       }
//       return ITenant.fromJsonList(response.body);
//     } else {
//       throw InternalServerError(term: response.body.toString());
//     }
//   }

//   bool isEmail(String input) {
//     // Implement your logic to check if input is an email
//     // You can use regular expressions or any other email validation mechanism
//     // For simplicity, this example checks if the input contains '@'
//     return input.contains('@');
//   }

//   @override
//   Future<IUser> login(
//       {required String userPhone, required bool skipDefaultAppSetup}) async {
//     log(userPhone, name: "userPhoneLoginWith");
//     String phoneNumber = userPhone;

//     if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
//       phoneNumber = '+' + phoneNumber;
//     }
//     http.Response response;
//     String? uid = firebase.FirebaseAuth.instance.currentUser?.uid ?? null;

//     response = await flipperHttpClient.post(
//       Uri.parse(apihub + '/v2/api/user'),
//       body: jsonEncode(
//         <String, String?>{'phoneNumber': phoneNumber, 'uid': uid},
//       ),
//     );

//     if (response.statusCode == 200 && response.body.isNotEmpty) {
//       // Parse the JSON response
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);

//       // Create an IUser object using the fromJson constructor
//       IUser user = IUser.fromJson(jsonResponse);
//       await ProxyService.box.writeString(
//         key: 'userPhone',
//         value: userPhone,
//       );
//       await ProxyService.box.writeString(
//         key: 'bearerToken',
//         value: user.token,
//       );
//       log(user.toJson().toString(), name: "loggedIn");

//       /// the token from firebase that link this user with firebase
//       /// so it can be used to login to other devices
//       await ProxyService.box.writeString(
//         key: 'uid',
//         value: user.uid,
//       );
//       await ProxyService.box.writeInt(
//         key: 'userId',
//         value: user.id!,
//       );

//       if (user.tenants.isEmpty) {
//         throw BusinessNotFoundException(
//             term:
//                 "No tenant added to the user, if a business is added it should have one tenant");
//       }
//       if (user.tenants.first.businesses.isEmpty ||
//           user.tenants.first.branches.isEmpty) {
//         throw BusinessNotFoundException(
//             term:
//                 "No tenant added to the user, if a business is added it should have one tenant");
//       }
//       await ProxyService.box.writeInt(
//         key: 'branchId',
//         value: user.tenants.isEmpty ? 0 : user.tenants.first.branches.first.id!,
//       );

//       log(user.id.toString(), name: 'login');
//       await ProxyService.box.writeInt(
//         key: 'businessId',
//         value:
//             user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id!,
//       );
//       await ProxyService.box.writeString(
//         key: 'encryptionKey',
//         value: user.tenants.first.businesses.first.encryptionKey,
//       );
//       if (skipDefaultAppSetup == false) {
//         await ProxyService.box.writeString(
//           key: 'defaultApp',

//           /// because we don update default app from server
//           /// because we want the ability of switching apps to be entirely offline
//           /// then if we have a default app in the box we use it if it only different from "1"
//           value: user.tenants.isEmpty
//               ? 'null'
//               : ProxyService.box.getDefaultApp() != "1"
//                   ? ProxyService.box.getDefaultApp()
//                   : user.tenants.first.businesses.first.businessTypeId
//                       .toString(),
//         );
//       }

//       for (ITenant tenant in user.tenants) {
//         IITenant iTenant = IITenant(
//             isDefault: tenant.isDefault,
//             id: tenant.id,
//             name: tenant.name,
//             businessId: tenant.businessId,
//             nfcEnabled: tenant.nfcEnabled,
//             email: tenant.email,
//             userId: user.id!,
//             phoneNumber: tenant.phoneNumber,
//             pin: tenant.pin);

//         isar.writeTxn(() async {
//           isar.iBusiness.putAll(tenant.businesses);
//         });
//         isar.writeTxn(() async {
//           isar.iBranchs.putAll(tenant.branches);
//         });
//         isar.writeTxn(() async {
//           isar.iPermissions.putAll(tenant.permissions);
//         });

//         isar.writeTxn(() async {
//           if (user.id == iTenant.userId) {
//             iTenant.sessionActive = true;
//             isar.iITenants.put(iTenant);
//           } else {
//             isar.iITenants.put(iTenant);
//           }
//         });
//       }
//       return user;
//     } else if (response.statusCode == 401) {
//       throw SessionException(term: "session expired");
//     } else if (response.statusCode == 500) {
//       throw ErrorReadingFromYBServer(term: "Not found");
//     } else {
//       log(response.body.toString(), name: "login error");
//       throw Exception(response.body.toString());
//     }
//   }

//   @override
//   Future<ITransaction?> pendingTransaction(
//       {required int branchId, required String transactionType}) async {
//     final transaction = await isar.iTransactions
//         .filter()
//         .statusEqualTo(PENDING)
//         // .and()
//         .branchIdEqualTo(branchId)
//         // .and()
//         .transactionTypeEqualTo(transactionType)
//         // .and()
//         .deletedAtIsNull()
//         .findFirst();
//     return transaction;
//   }

//   @override
//   Future<Profile?> profile({required int businessId}) async {
//     return await isar.profiles
//         .filter()
//         .businessIdEqualTo(businessId)
//         .findFirst();
//   }

//   @override
//   Future<void> saveDiscount(
//       {required int branchId, required name, double? amount}) async {
//     //save discount into isar isar
//     isar.writeTxn(() async {
//       Discount discount = Discount(
//         amount: amount,
//         id: randomNumber(),
//         branchId: branchId,
//         name: name,
//       );
//       isar.discounts.put(discount);
//     });
//   }

//   @override
//   Future<int> sendReport({required List<TransactionItem> transactionItems}) {
//     // TODO: implement sendReport
//     return Future.value(200);
//   }

//   @override
//   Future<Spenn> spennPayment(
//       {required double amount, required phoneNumber}) async {
//     int userId = ProxyService.box.getUserId()!;
//     var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
//     IBusiness bu = await getBusiness();
//     // ignore: fixme
//     // FIXME: this endpoint is no longer working
//     String businessName = bu!.name!;
//     var request =
//         http.Request('POST', Uri.parse('https://flipper.yegobox.com/pay'));
//     request.bodyFields = {
//       'amount': amount.toString(),
//       'userId': userId.toString(),
//       'RequestGuid': '00HK-KLJS',
//       'paymentType': 'SPENN',
//       'itemName': ' N/A',
//       'note': ' N/A',
//       'createdAt': DateTime.now().toIso8601String(),
//       'phoneNumber': '+25' + phoneNumber,
//       'message': 'Pay ' + businessName,
//     };
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     String body = await response.stream.bytesToString();

//     return spennFromJson(body);
//   }

//   @override
//   Future<Stock?> stockByVariantId(
//       {required int variantId, bool nonZeroValue = false}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     await assignStockToVariant(variantId: variantId);
//     if (nonZeroValue) {
//       return await isar.stocks
//           .filter()
//           .variantIdEqualTo(variantId)
//           .and()
//           .branchIdEqualTo(branchId)
//           .and()
//           .retailPriceGreaterThan(0)
//           .and()
//           .deletedAtIsNull()
//           .findFirst();
//     } else {
//       return await isar.stocks
//           .filter()
//           .variantIdEqualTo(variantId)
//           .and()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .findFirst();
//     }
//   }

//   @override
//   Stream<double> getStockValue({required int branchId}) async* {
//     //
//     while (true) {
//       double totalStock = 0.0;
//       final stocks =
//           await isar.stocks.filter().branchIdEqualTo(branchId).findAll();
//       totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.value ?? 0));
//       yield totalStock;
//       await Future.delayed(Duration(seconds: 1));
//     }
//   }

//   @override
//   Stream<double> getStockStream({int? productId, int? variantId}) async* {
//     while (true) {
//       double totalStock = 0.0;
//       if (productId != null) {
//         final stocks =
//             await isar.stocks.filter().productIdEqualTo(productId).findAll();
//         totalStock = stocks.fold(0.0, (sum, stock) => sum + stock.currentStock);
//       } else if (variantId != null) {
//         final stocks =
//             await isar.stocks.filter().variantIdEqualTo(variantId).findAll();
//         totalStock = stocks.fold(0.0, (sum, stock) => sum + stock.currentStock);
//       }
//       yield totalStock;
//       await Future.delayed(Duration(seconds: 1));
//     }
//   }

//   @override
//   Future<double> stocks({int? productId, int? variantId}) async {
//     double totalStock = 0.0;

//     // If productId is given, compute the total stock for all variants and return it
//     // Otherwise, get the stock for a single variant based on variantId
//     if (productId != null) {
//       // Query Isar database to find all stocks with a matching productId
//       final stocks =
//           await isar.stocks.filter().productIdEqualTo(productId).findAll();

//       // Sum up the stock quantities for all variants with the given productId
//       totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
//     } else if (variantId != null) {
//       // Query Isar database to find all stocks with a matching variantId
//       final stocks =
//           await isar.stocks.filter().variantIdEqualTo(variantId).findAll();

//       // Sum up the stock quantities for the variant with the given variantId
//       totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
//     }
//     return totalStock;
//   }

//   @override
//   bool subscribe(
//       {required String feature,
//       required int businessId,
//       required int agentCode}) {
//     // TODO: implement subscribe
//     throw UnimplementedError();
//   }

//   @override
//   bool suggestRestore() {
//     // TODO: implement suggestRestore
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> syncProduct(
//       {required Product product,
//       required Variant variant,
//       required Stock stock}) {
//     // TODO: implement syncProduct
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<ITransaction>> tickets() async {
//     return await isar.iTransactions
//         .filter()
//         .statusEqualTo(PARKED)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   @override
//   Future<List<IUnit>> units({required int branchId}) async {
//     final existingUnits =
//         await isar.iUnits.filter().branchIdEqualTo(branchId).findAll();

//     // If units are already present, return them
//     if (existingUnits.isNotEmpty) {
//       return existingUnits;
//     }

//     // If units are not present, add them and return the added units
//     await addUnits(units: mockUnits);

//     return await isar.iUnits
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   @override
//   T? create<T>({required T data}) {
//     /// update user activity model

//     if (data is Counter) {
//       Counter counter = data;
//       isar.writeTxn(() async {
//         isar.counters.put(counter);
//         // Return the created conversation
//       }); // Cast the result to type T
//       return isar.counters.get(counter.id!) as T;
//     }

//     /// end with updating user activity
//     if (data is Conversation) {
//       Conversation conversation = data;
//       isar.writeTxn(() async {
//         isar.conversations.put(conversation);
//         // Return the created conversation
//       }); // Cast the result to type T
//       return isar.conversations.get(conversation.id!) as T;
//     }

//     if (data is PColor) {
//       PColor color = data;
//       isar.writeTxn(() async {
//         for (String colorName in data.colors!) {
//           isar.pColors.put(PColor(
//               id: randomNumber(),
//               lastTouched: DateTime.now(),
//               action: AppActions.created,
//               name: colorName,
//               active: color.active,
//               branchId: color.branchId));
//         }
//       });
//     }
//     if (data is Device) {
//       Device device = data;
//       isar.writeTxn(() async {
//         isar.devices.onPut(device);
//       });
//       return null;
//     }
//     if (data is Conversation) {
//       Conversation conversation = data;
//       isar.writeTxn(() async {
//         isar.conversations.put(conversation);
//       });
//       return null;
//     }
//     if (data is Category) {
//       Category category = data;
//       isar.writeTxn(() async {
//         isar.categorys.put(category);
//       });
//       return null;
//     }
//     if (data is Product) {
//       isar.writeTxn(() async {
//         return isar.products.onPut(data);
//       });
//     }
//     if (data is Variant) {
//       isar.writeTxn(() async {
//         isar.variants.onPut(data);
//       });
//       return null;
//     }
//     if (data is Favorite) {
//       isar.writeTxn(() async {
//         isar.favorites.onPut(data);
//       });
//       return null;
//     }
//     if (data is Stock) {
//       isar.writeTxn(() async {
//         isar.stocks.onPut(data);
//       });
//       return null;
//     }
//     if (data is Social) {
//       isar.writeTxn(() async {
//         isar.socials.put(data);
//       });
//       return null;
//     }
//     if (data is Token) {
//       isar.writeTxn(() async {
//         isar.tokens.put(data);
//       });
//       return null;
//     }
//     if (data is Setting) {
//       isar.writeTxn(() async {
//         isar.settings.put(data);
//       });
//       return null;
//     }
//     if (data is EBM) {
//       isar.writeTxn(() async {
//         isar.eBMs.put(data);
//       });
//       return null;
//     }
//     if (data is ITransaction) {
//       isar.writeTxn(() async {
//         isar.iTransactions.onPut(data);
//       });
//       return null;
//     }
//     if (data is TransactionItem) {
//       isar.writeTxn(() async {
//         isar.transactionItems.onPut(data);
//       });
//       return null;
//     }
//     return null;
//   }

//   /// @Deprecated [endpoint] don't give the endpoint params
  // @override
  // Future<int> update<T>({required T data, bool localUpdate = false}) async {
  //   /// update user activity
  //   int userId = ProxyService.box.getUserId() ?? 0;
  //   if (userId == 0) return 0;

  //   /// end updating user activity
  //   // int branchId = ProxyService.box.getBranchId()!;
  //   if (data is Device) {
  //     Device device = data;

  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.devices.onUpdate(device);
  //       } else {
  //         isar.devices.onPut(device);
  //       }
  //     });
  //   }
  //   if (data is Social) {
  //     Social social = data;

  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.socials.onUpdate(social);
  //       } else {
  //         isar.socials.onPut(social);
  //       }
  //     });
  //   }
  //   if (data is Product) {
  //     Product product = data;
  //     product.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.products.onUpdate(product);
  //       } else {
  //         isar.products.onPut(product);
  //       }
  //     });
  //   }
  //   if (data is Favorite) {
  //     Favorite fav = data;
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.favorites.onUpdate(fav);
  //       } else {
  //         isar.favorites.onPut(fav);
  //       }
  //     });
  //   }
  //   if (data is Variant) {
  //     Variant variant = data;
  //     variant.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.variants.onUpdate(variant);
  //       } else {
  //         isar.variants.onPut(variant);
  //       }
  //     });
  //   }
  //   if (data is Stock) {
  //     Stock stock = data;
  //     stock.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.stocks.onUpdate(stock);
  //       } else {
  //         isar.stocks.onPut(stock);
  //       }
  //     });
  //   }
  //   if (data is ITransaction) {
  //     final transaction = data;
  //     transaction.lastTouched =
  //         DateTime.now().toLocal().add(Duration(hours: 2));
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.iTransactions.onUpdate(transaction);
  //       } else {
  //         isar.iTransactions.onPut(transaction);
  //       }
  //     });
  //   }
  //   if (data is Category) {
  //     final category = data;
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.categorys.onUpdate(category);
  //       } else {
  //         isar.categorys.onPut(category);
  //       }
  //     });
  //   }
  //   if (data is IUnit) {
  //     final unit = data;
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.iUnits.onUpdate(unit);
  //       } else {
  //         isar.iUnits.onPut(unit);
  //       }
  //     });
  //   }
  //   if (data is PColor) {
  //     final color = data;
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.pColors.onUpdate(color);
  //       } else {
  //         isar.pColors.onPut(color);
  //       }
  //     });
  //   }
  //   if (data is TransactionItem) {
  //     data.lastTouched = DateTime.now().toLocal();
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.transactionItems.onUpdate(data);
  //       } else {
  //         isar.transactionItems.onPut(data);
  //       }
  //     });
  //   }
  //   if (data is EBM) {
  //     final ebm = data;
  //     isar.writeTxn(() async {
  //       ProxyService.box
  //           .writeString(key: "serverUrl", value: ebm.taxServerUrl ?? 'null');
  //       IBusiness business =
  //           await isar.iBusiness.filter().userIdEqualTo(ebm.userId).findFirst();
  //       business
  //         ?..dvcSrlNo = ebm.dvcSrlNo
  //         ..tinNumber = ebm.tinNumber
  //         ..bhfId = ebm.bhfId
  //         ..taxServerUrl = ebm.taxServerUrl
  //         ..taxEnabled = true;
  //       if (localUpdate) {
  //         isar.iBusiness.onUpdate(business!);
  //       } else {
  //         isar.iBusiness.onPut(business!);
  //       }
  //     });
  //   }
  //   if (data is Token) {
  //     final token = data;
  //     token
  //       ..token = token.token
  //       ..businessId = token.businessId
  //       ..type = token.type;
  //     isar.writeTxn(() async {
  //       if (localUpdate) {
  //         isar.tokens.onUpdate(token);
  //       } else {
  //         isar.tokens.onPut(token);
  //       }
  //     });
  //   }
  //   if (data is IBusiness) {
  //     final business = data;
  //     isar.writeTxn(() async {
  //       isar.iBusiness.put(business);
  //     });
  //     final response = await flipperHttpClient.patch(
  //       Uri.parse("$apihub/v2/api/business/${business.id}"),
  //       body: jsonEncode(business.toJson()),
  //     );
  //     if (response.statusCode != 200) {
  //       throw InternalServerError(term: "error patching the business");
  //     }
  //   }

  //   if (data is IBranch) {
  //     isar.writeTxn(() async {
  //       isar.iBranchs.put(data);
  //     });
  //     final response = await flipperHttpClient.patch(
  //       Uri.parse("$apihub/v2/api/branch/${data.id}"),
  //       body: jsonEncode(data.toJson()),
  //     );
  //     if (response.statusCode != 200) {
  //       throw InternalServerError(term: "error patching the branch");
  //     }
  //   }
  //   if (data is Counter) {
  //     Counter? iCounter = await isar.counters
  //         .filter()
  //         .receiptTypeEqualTo(data.receiptType.toUpperCase())
  //         .findFirst();
  //     if (iCounter != null) {
  //       iCounter.totRcptNo = data.totRcptNo;
  //       iCounter.curRcptNo = data.curRcptNo;
  //       isar.writeTxn(() async {
  //         isar.counters.onPut(iCounter);
  //       });
  //     } else {
  //       isar.writeTxn(() async {
  //         isar.counters.onPut(data);
  //       });
  //     }

  //     // final response = await flipperHttpClient.patch(
  //     //   Uri.parse("$apihub/v2/api/counter/${data.id}"),
  //     //   body: jsonEncode(data.toJson()),
  //     // );
  //     // if (response.statusCode == 200) {
  //     //   log(response.body, name: 'response.body');
  //     //   Counter counter = Counter.fromRawJson(response.body);
  //     //   isar. writeTxn(() {
  //     //     isar.counters.onPut(data
  //     //       ..branchId = counter.branchId
  //     //       ..businessId = counter.businessId
  //     //       ..receiptType = counter.receiptType
  //     //       ..id = data.id
  //     //       ..totRcptNo = counter.totRcptNo
  //     //       ..curRcptNo = counter.curRcptNo);
  //     //   });
  //     // } else {
  //     //   throw InternalServerError(term: "error patching the counter");
  //     // }
  //   }
  //   if (data is IBranch) {
  //     isar.writeTxn(() async {
  //       isar.iBranchs.put(data);
  //     });
  //     try {
  //       await flipperHttpClient.patch(
  //         Uri.parse("$apihub/v2/api/branch/${data.id}"),
  //         body: jsonEncode(data.toJson()),
  //       );
  //     } catch (e) {}
  //   }
  //   if (data is Drawers) {
  //     final drawer = data;
  //     drawer.lastTouched = DateTime.now().toLocal();
  //     isar.writeTxn(() async {
  //       isar.drawers.onPut(drawer);
  //     });
  //   }
  //   if (data is User) {
  //     final response = await flipperHttpClient.patch(
  //       Uri.parse("$apihub/v2/api/user"),
  //       body: jsonEncode(data.toJson()),
  //     );
  //     return response.statusCode;
  //   }
  //   if (data is IITenant) {
  //     final response = await flipperHttpClient.patch(
  //       Uri.parse("$apihub/v2/api/tenant/${data.id}"),
  //       body: jsonEncode(data.toJson()),
  //     );
  //     if (response.statusCode == 200) {
  //       isar.writeTxn(() async {
  //         isar.iITenants.onPut(data);
  //       });
  //     }
  //     return response.statusCode;
  //   }
  //   return 0;
  // }

//   @override
//   Future<Profile?> updateProfile({required Profile profile}) async {
//     //TODO:check if the profile is property updated.
//     isar.writeTxn(() async {
//       isar.profiles.put(profile);
//     });
//     return await isar.profiles.get(profile.id!);
//   }

//   @override
//   Future<int> userNameAvailable({required String name}) async {
//     final response =
//         await flipperHttpClient.get(Uri.parse("$apihub/search?name=$name"));
//     return response.statusCode;
//   }

//   @override
//   Future<Variant?> variant({int? variantId, String? name}) async {
//     if (variantId != null) {
//       return isar.variants.get(variantId);
//     }
//     if (name != null) {
//       return await isar.variants
//           .filter()
//           .nameEqualTo(name)
//           .and()
//           .deletedAtIsNull()
//           .findFirst();
//     }
//     return null;
//   }

//   @override
//   Future<List<Variant>> getVariantByProductId({int? productId}) async {
//     return isar.variants
//         .filter()
//         .productIdEqualTo(productId ?? 0)
//         .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   @override
//   Future<List<Variant>> variants(
//       {required int branchId, int? productId}) async {
//     if (productId != null) {
//       return await isar.variants
//           .filter()
//           .productIdEqualTo(productId)
//           .and()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .and()
//           .retailPriceGreaterThan(0)
//           // .and()
//           // .supplyPriceGreaterThan(0)
//           .findAll();
//     } else {
//       return await isar.variants
//           .filter()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .and()
//           .retailPriceGreaterThan(0)
//           .and()
//           .supplyPriceGreaterThan(0)
//           .findAll();
//     }
//   }

//   List<DateTime> getWeeksForRange(DateTime start, DateTime end) {
//     var result = [];
//     var date = start;
//     List<DateTime> week = [];

//     while (date.difference(end).inDays <= 0) {
//       // start new week on Monday
//       if (date.weekday == 1 && week.isNotEmpty) {
//         result.add(week);
//       }

//       week.add(date);
//       date = date.add(const Duration(days: 1));
//     }
//     return week;
//   }

//   /// An override of the [productsFuture] method to fetch a list of products
//   /// based on the specified branch ID and additional filtering criteria.
//   ///
//   /// This method retrieves products from the database, filtering out those
//   /// with a name equal to 'temp' or 'custom', and excluding deleted items.
//   /// The result is limited to a maximum of 10 products and only includes
//   /// products that have been modified within the last 7 days.
//   ///
//   /// Parameters:
//   ///   - [branchId]: The identifier of the branch for which products are fetched.
//   ///
//   /// Returns:
//   ///   A [Future] that completes with a [List] of [Product] objects.
//   @override
//   Future<List<Product>> productsFuture({required int branchId}) async {
//     // Fetch all products based on branch ID and additional criteria
//     List<Product> allProducts = await isar.products
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull()
//         .and()
//         .lastTouchedGreaterThan(
//             DateTime.now().subtract(const Duration(days: 7)))
//         .limit(7)
//         .findAll();
//     // if we have no recent product please load without the condition
//     if (allProducts.isEmpty) {
//       allProducts = await isar.products
//           .filter()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .limit(7)
//           .findAll();
//     }

//     // Filter out products with the name 'temp' or 'custom'
//     final filteredProducts = allProducts
//         .where((product) =>
//             product.name != TEMP_PRODUCT && product.name != CUSTOM_PRODUCT)
//         .toList();

//     // Return the filtered list of products
//     return filteredProducts;
//   }

//   @override
//   Future<List<Category>> categories({required int branchId}) async {
//     // get all categories from isar isar
//     return await isar.categorys.filter().branchIdEqualTo(branchId).findAll();
//   }

//   @override
//   Future<Category?> activeCategory({required int branchId}) async {
//     // get all categories from isar isar
//     return await isar.categorys
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .activeEqualTo(true)
//         .and()
//         .focusedEqualTo(true)
//         .and()
//         .deletedAtIsNull()
//         .findFirst();
//   }

//   @override
//   Future<Variant?> getVariantById({required int id}) async {
//     return await isar.variants.get(id);
//   }

//   @override
//   Future<Receipt?> createReceipt(
//       {required EBMApiResponse signature,
//       required ITransaction transaction,
//       required String qrCode,
//       required Counter counter,
//       required String receiptType}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     Receipt receipt = Receipt(
//       id: randomNumber(),
//       branchId: branchId,
//       resultCd: signature.resultCd,
//       resultMsg: signature.resultMsg,
//       rcptNo: signature.data?.rcptNo ?? 0,
//       intrlData: signature.data?.intrlData ?? "",
//       rcptSign: signature.data?.rcptSign ?? "",
//       qrCode: qrCode,
//       receiptType: receiptType,
//       vsdcRcptPbctDate: signature.data?.vsdcRcptPbctDate ?? "",
//       sdcId: signature.data?.sdcId ?? "",
//       totRcptNo: signature.data?.totRcptNo ?? 0,
//       mrcNo: signature.data?.mrcNo ?? "",
//       transactionId: transaction.id!,
//       resultDt: signature.resultDt ?? "",
//     );

//     isar.writeTxn(() async {
//       isar.receipts.put(receipt);
//     });
//     return isar.receipts.get(receipt.id!);
//   }

//   @override
//   Future<Receipt?> getReceipt({required int transactionId}) async {
//     return await isar.receipts
//         .filter()
//         .transactionIdEqualTo(transactionId)
//         .findFirst();
//   }

//   @override
//   Future<void> refund({required int itemId}) async {
//     return isar.writeTxn(() async {
//       TransactionItem? item = await isar.transactionItems.get(itemId);
//       item!.isRefunded = true;
//       isar.transactionItems.onPut(item);
//     });
//   }

//   @override
//   Future<bool> isDrawerOpen({required int cashierId}) async {
//     Drawers? drawer = await isar.drawers
//         .filter()
//         .openEqualTo(true)
//         .and()
//         .cashierIdEqualTo(cashierId)
//         .findFirst();
//     return drawer != null;
//   }

//   @override
//   Future<Drawers?> getDrawer({required int cashierId}) async {
//     return await isar.drawers
//         .filter()
//         .openEqualTo(true)
//         .and()
//         .cashierIdEqualTo(cashierId)
//         .findFirst();
//   }

//   @override
//   Future<Drawers?> openDrawer({required Drawers drawer}) async {
//     // save drawer object in isar isar
//     int id = randomNumber();
//     await isar.writeTxn(() async {
//       isar.drawers.put(drawer..id = id);
//     });
//     return await isar.drawers.get(id);
//   }

//   @override
//   Future<int> size<T>({required T object}) async {
//     if (object is Product) {
//       return await isar.products.getSize(includeIndexes: true);
//     }
//     if (object is Variant) {
//       return await isar.variants.getSize(includeIndexes: true);
//     }
//     if (object is Stock) {
//       return await isar.stocks.getSize(includeIndexes: true);
//     }
//     if (object is Counter) {
//       return await isar.counters.getSize(includeIndexes: true);
//     }
//     return 0;
//   }

//   @override
//   Future<List<IITenant>> tenants({int? businessId}) async {
//     if (businessId != null) {
//       return isar.iITenants.filter().businessIdEqualTo(businessId).findAll();
//     } else {
//       return isar.iITenants.filter().deletedAtIsNull().findAll();
//     }
//   }

//   @override
//   Future<List<IITenant>> tenantsFromOnline({required int businessId}) async {
//     final http.Response response = await flipperHttpClient
//         .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
//     if (response.statusCode == 200) {
//       for (ITenant tenant in ITenant.fromJsonList(response.body)) {
//         ITenant jTenant = tenant;
//         IITenant iTenant = IITenant(
//             isDefault: jTenant.isDefault,
//             id: jTenant.id,
//             name: jTenant.name,
//             userId: jTenant.userId,
//             businessId: jTenant.businessId,
//             nfcEnabled: jTenant.nfcEnabled,
//             email: jTenant.email,
//             phoneNumber: jTenant.phoneNumber);

//         isar.writeTxn(() async {
//           isar.iBusiness.putAll(jTenant.businesses);
//           isar.iBranchs.putAll(jTenant.branches);
//           isar.iPermissions.putAll(jTenant.permissions);
//         });
//         isar.writeTxn(() async {
//           isar.iITenants.put(iTenant);
//         });
//       }
//       return await isar.iITenants
//           .filter()
//           .businessIdEqualTo(businessId)
//           .findAll();
//     }
//     throw InternalServerException(term: "we got unexpected response");
//   }

//   @override
//   Future<Branch> defaultBranch() async {
//     return await isar.iBranchs.filter().isDefaultEqualTo(true).findFirst();
//   }

//   @override
//   Future<IBusiness> defaultBusiness() async {
//     return await isar.iBusiness.filter().isDefaultEqualTo(true).findFirst();
//   }

//   @override
//   Future<Counter?> getCounter(
//       {required int branchId, required String receiptType}) async {
//     return await isar.counters
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .receiptTypeEqualTo(receiptType, caseSensitive: false)
//         .findFirst();
//   }

//   // @override
//   // Future<Counter?> nRSCounter({required int branchId}) async {
//   //   return isar.read((isar) => isar.counters
//   //       .filter()
//   //       .branchIdEqualTo(branchId)
//   //       .and()
//   //       .receiptTypeEqualTo(ReceiptType.nr)
//   //       .findFirst());
//   // }

//   // @override
//   // Future<Counter?> nSCounter({required int branchId}) async {
//   //   return isar.read((isar) => isar.counters
//   //       .filter()
//   //       .branchIdEqualTo(branchId)
//   //       .and()
//   //       .receiptTypeEqualTo(ReceiptType.ns)
//   //       .findFirst());
//   // }

//   // @override
//   // Future<Counter?> pSCounter({required int branchId}) async {
//   //   return isar.read((isar) => isar.counters
//   //       .filter()
//   //       .branchIdEqualTo(branchId)
//   //       .and()
//   //       .receiptTypeEqualTo(ReceiptType.ps)
//   //       .findFirst());
//   // }

//   // @override
//   // Future<Counter?> tSCounter({required int branchId}) async {
//   //   return isar.read((isar) => isar.counters
//   //       .filter()
//   //       .branchIdEqualTo(branchId)
//   //       .and()
//   //       .receiptTypeEqualTo(ReceiptType.ts)
//   //       .findFirst());
//   // }

//   @override
//   Future<void> loadCounterFromOnline({required int businessId}) async {
//     final http.Response response = await flipperHttpClient
//         .get(Uri.parse("$apihub/v2/api/counter/$businessId"));

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonResponse = json.decode(response.body);
//       List<Counter> counters = Counter.fromJsonList(jsonResponse);

//       /// first check if we don't have local counter that we are overwriting
//       List<Counter> localCounters =
//           await isar.counters.filter().deletedAtIsNull().findAll();
//       if (localCounters.isNotEmpty) return;
//       for (Counter counter in counters) {
//         isar.writeTxn(() async {
//           isar.counters.put(Counter(
//             id: counter.id,
//             branchId: counter.branchId,
//             businessId: counter.businessId,
//             totRcptNo: counter.totRcptNo,
//             curRcptNo: counter.curRcptNo,
//             receiptType: counter.receiptType,
//           ));
//         });
//       }
//     } else {
//       throw InternalServerError(term: "Error loading the counters");
//     }
//   }

//   @override
//   Future<bool> bindProduct(
//       {required int productId, required int tenantId}) async {
//     final product = await isar.products.get(productId);
//     product!.nfcEnabled = true;
//     product.bindedToTenantId = tenantId;
//     isar.writeTxn(() async {
//       isar.products.onPut(product);
//     });
//     return true;
//   }

//   @override
//   Future<Product?> findProductByTenantId({required int tenantId}) async {
//     return isar.products.filter().bindedToTenantIdEqualTo(tenantId).findFirst();
//   }

//   @override
//   Future<List<Product>> products({required int branchId}) async {
//     return await isar.products.filter().branchIdEqualTo(branchId).findAll();
//   }

// // https://pub.dev/packages/excel
//   @override
//   Future<List<ITransaction>> completedTransactions(
//       {required int branchId, String? status = COMPLETE}) async {
//     return isar.iTransactions
//         .filter()
//         .statusEqualTo(status!)
//         .and()
//         .branchIdEqualTo(branchId)
//         .sortByCreatedAtDesc()
//         .findAll();
//   }

//   /// Do not call this function in production
//   @override
//   Future<void> deleteAllProducts() async {
//     List<Product> products =
//         await productsFuture(branchId: ProxyService.box.getBranchId()!);
//     List<int> productIds = products.map((product) => product.id!).toList();
//     isar.writeTxn(() async {
//       isar.products.deleteAll(productIds);
//     });
//   }

//   @override
//   Future<Stock?> getStockById({required int id}) async {
//     return await isar.stocks.get(id);
//   }

//   /// sincd this type does not change no point of getting it from the server
//   @override
//   Future<List<BusinessType>> businessTypes() async {
//     final responseJson = [
//       {"id": "1", "typeName": "Flipper Retailer"},
//       // {"id": "2", "typeName": "Flipper Connecta"},`
//     ];
//     Future.delayed(Duration(seconds: 5));
//     final response = http.Response(jsonEncode(responseJson), 200);
//     if (response.statusCode == 200) {
//       return BusinessType.fromJsonList(jsonEncode(responseJson));
//     }
//     return BusinessType.fromJsonList(jsonEncode(responseJson));
//   }

//   @override
//   Future<Social?> getSocialById({required int id}) async {
//     return isar.socials.get(id);
//   }

//   /// Given businessId return if there is any social account set for this business
//   /// this will give us enough confidence that we can authenticate social api as there is
//   /// probably one account set which means we can get bearer token if we authenticate with service
//   @override
//   Future<List<Social>> activesocialAccounts({required int branchId}) async {
//     return await isar.socials
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .isAccountSetEqualTo(true)
//         .findAll();
//   }

//   final appService = loc.getIt<AppService>();
//   @override
//   Future<List<Conversation>> getScheduleMessages() async {
//     return await isar.conversations.filter().deliveredEqualTo(false).findAll();
//   }

//   @override
//   Future<void> sendScheduleMessages() async {
//     try {
//       await appService.isLoggedIn();
//       List<Conversation> scheduledMessages = await getScheduleMessages();
//       for (Conversation message in scheduledMessages) {
//         final http.Response response = await flipperHttpClient.post(
//           Uri.parse("$commApi/reply"),
//           body: json.encode(message.toJson()),
//         );
//         if (response.statusCode == 200) {
//           final responseJson = jsonDecode(response.body);
//           final conversation = Conversation.fromJson(responseJson);
//           message.delivered = true;
//           message.messageId = conversation.messageId;

//           /// can not rely on remote server time using local, will fix remote later
//           /// to have same date format as here and use it
//           message.createdAt = DateTime.now().toString();
//           message.conversationId = conversation.conversationId;
//           message.userName = conversation.userName;
//           message.phoneNumberId = conversation.phoneNumberId;
//           message.businessPhoneNumber =
//               ProxyService.box.getUserPhone()!.replaceAll("+", "");
//           await isar.conversations.put(message);
//         } else {
//           // this means there is no credit
//           throw Exception(
//               'Error sending scheduled message${response.body}${response.statusCode}');
//         }
//       }

//       /// silently avoid the app to hand in debug mode
//       /// because of the error found in   await appService.isLoggedIn(); firebase auth object
//     } catch (e) {}
//   }

//   @override
//   Future<Conversation?> getConversation({required String messageId}) async {
//     return await isar.conversations
//         .filter()
//         .messageIdEqualTo(messageId)
//         .findFirst();
//   }

//   @override
//   Future<int> registerOnSocial(
//       {String? phoneNumberOrEmail, String? password}) async {
//     final http.Response response = await flipperHttpClient.post(
//       Uri.parse("$commApi/register"),
//       body: json.encode({"email": phoneNumberOrEmail, "password": password}),
//     );
//     if (response.statusCode == 200) {
//       return Future.value(200);
//     }

//     // var headers = {'Content-Type': 'application/json'};
//     // var request = http.Request('POST', Uri.parse("$commApi/register"));
//     // request.body =
//     //     json.encode({"email": phoneNumberOrEmail, "password": password});
//     // request.headers.addAll(headers);

//     // http.StreamedResponse response = await request.send();

//     // if (response.statusCode == 200) {
//     //   print(await response.stream.bytesToString());
//     // }
//     throw Exception();
//   }

//   @override
//   Future<bool> isTokenValid({
//     required String tokenType,
//     required int businessId,
//   }) async {
//     final token = await isar.tokens
//         .filter()
//         .typeEqualTo(tokenType)
//         .and()
//         .businessIdEqualTo(businessId)
//         .findFirst();

//     if (token == null) {
//       return false;
//     }

//     final now = DateTime.now();

//     if (token.validFrom != null && token.validUntil != null) {
//       if (now.isBefore(token.validFrom!) || now.isAfter(token.validUntil!)) {
//         isar.tokens.delete(token.id!);
//         return false;
//       }
//     } else {
//       return false;
//     }
//     String? localToken = ProxyService.box.whatsAppToken();
//     if (localToken == null) {
//       return false;
//     }
//     return true;
//   }

//   @override
//   Future<SocialToken?> loginOnSocial(
//       {String? phoneNumberOrEmail, String? password}) async {
//     final http.Response response = await flipperHttpClient.post(
//       Uri.parse("$commApi/login"),
//       body: json.encode({"email": phoneNumberOrEmail, "password": password}),
//     );

//     if (response.statusCode == 200) {
//       SocialToken responseBody = SocialToken.fromRawJson(response.body);
//       return responseBody;
//     } else {
//       //// TODO: this is not a stopper when performing app global login
//       /// instead implement global non fatal error reporting so it can be addressed separately
//       // throw Exception("Failed to get token");
//       return null;
//     }
//   }

//   /// Retrieves the social setting asynchronously.
//   ///
//   /// This function retrieves the social setting based on the user's phone number.
//   /// If the user's phone number is not available, it returns `null`.
//   /// It first checks if the setting is available in the `isar.settings` database using the user's phone number.
//   /// If the setting is found, it returns the setting.
//   /// If the setting is not found in the database, it makes an HTTP GET request to the flipperHttpClient
//   /// to fetch the setting from the specified API endpoint.
//   /// If the HTTP response status code is 200, it converts the response body to a `Setting` object
//   /// using `Setting.fromJson()` and then saves it using the `create()` function.
//   /// Finally, it returns the fetched or created setting.
//   /// If the HTTP response status code is not 200, it throws an exception with a descriptive error message.
//   ///
//   /// Returns:
//   ///   - A `Future` of type `Setting?` representing the retrieved social setting.
//   ///     If the user's phone number is not available, it returns `null`.
//   ///
//   /// Throws:
//   ///   - An `Exception` with an error message if the HTTP response status code is not 200.
//   ///     The error message includes the response body and the user's phone number.

//   @override
//   Future<Setting?> getSocialSetting() async {
//     String? phoneNumber = ProxyService.box.getUserPhone();
//     if (phoneNumber == null) {
//       return null;
//     }

//     final number = phoneNumber.replaceAll("+", "");

//     Setting? setting = await isar.settings
//         .filter()
//         .businessPhoneNumberEqualTo(number)
//         .findFirst();

//     if (setting != null) {
//       return setting;
//     }
//     Future.delayed(Duration(seconds: 20));
//     final Uri uri = Uri.parse("$commApi/settings/$number");
//     final http.Response response = await flipperHttpClient.get(uri);

//     if (response.statusCode == 200) {
//       Setting setting = Setting.fromJson(jsonDecode(response.body));
//       create(data: setting);
//       return setting;
//     } else {
//       throw Exception("Can't get social setting ${response.body}${number}");
//     }
//   }

//   @override
//   Future<void> patchSocialSetting({required Setting setting}) async {
//     /// a hack to delay 20 seconds for theserver to not return forbidden as we have called the aws api before
//     /// so we need to wait 20 seconds to make another call, I will need to investigate on server later
//     // await Future.delayed(Duration(seconds: 20));
//     int businessId = ProxyService.box.getBusinessId()!;
//     final http.Response response = await flipperHttpClient.patch(
//         Uri.parse("$commApi/settings"),
//         body: json.encode(
//             {"businessId": businessId, "deviceToken": setting.deviceToken}));
//     // convert response to Setting
//     if (response.statusCode != 200 && response.statusCode != 403) {
//       throw Exception(
//           "Can't  patch  settings patch ${response.body}${setting.toJson()}");
//     }
//   }

//   @override
//   Future<Device?> getDevice(
//       {required String phone, required String linkingCode}) async {
//     // get device from isar with linking code and return it
//     return await isar.devices
//         .filter()
//         .phoneEqualTo(phone)
//         .and()
//         .deletedAtIsNull()
//         .and()
//         .linkingCodeEqualTo(linkingCode)
//         .findFirst();
//   }

//   @override
//   Future<Device?> getDeviceById({required int id}) async {
//     // get device from isar with linking code and return it
//     return await isar.devices.filter().idEqualTo(id).findFirst();
//   }

//   @override
//   Future<List<Device>> unpublishedDevices({required int businessId}) async {
//     return await isar.devices
//         .filter()
//         .businessIdEqualTo(businessId)
//         .and()
//         .pubNubPublishedEqualTo(false)
//         .findAll();
//   }

//   @override
//   Future<IITenant?> getTenantBYUserId({required int userId}) async {
//     return await isar.iITenants.filter().userIdEqualTo(userId).findFirst();
//   }

//   @override
//   Future<IITenant?> getTenantBYPin({required int pin}) async {
//     return await isar.iITenants
//         .filter()
//         .pinEqualTo(pin)
//         .and()
//         .isDefaultEqualTo(true)
//         .findFirst();
//   }

//   /// Loads conversations from the server for a given business ID.
//   ///
//   /// The [businessId] parameter is required and specifies the ID of the business
//   /// for which conversations should be loaded.
//   ///
//   /// The [pageSize] parameter determines the number of conversations to retrieve
//   /// per page. If not provided, a default value of 10 is used.
//   ///
//   /// The [pk] and [sk] parameters allow for pagination and retrieving conversations
//   /// starting from a specific point in the conversation history.
//   ///
//   /// This function makes an HTTP request to the server, retrieves the conversations,
//   /// and stores them in a local database for future reference.
//   ///
//   /// Note: This function assumes a successful HTTP response with a status code of 200.
//   /// Errors during the request or JSON parsing are not handled in this implementation.
//   ///
//   /// Example usage:
//   /// ```
//   /// await loadConversations(businessId: 123, pageSize: 20);
//   /// ```
//   @override
//   Future<void> loadConversations(
//       {required int businessId,
//       int? pageSize = 1000,
//       String? pk,
//       String? sk}) async {
//     String? paginationCreatedAt = ProxyService.box.paginationCreatedAt();
//     int? paginationId = ProxyService.box.paginationId();

//     final response = await flipperHttpClient.get(Uri.parse(
//         '${commApi}/messages/${businessId}?pageSize=${pageSize}&createdAt=${paginationCreatedAt}&id=${paginationId}'));

//     if (response.statusCode == 200) {
//       final messagesJson = jsonDecode(response.body)['messages'];
//       if (messagesJson == null) return;
//       List<Conversation> messages = (messagesJson as List<dynamic>)
//           .map((e) => Conversation.fromJson(e))
//           .toList();

//       for (Conversation conversation in messages) {
//         Conversation? localConversation =
//             await getConversation(messageId: conversation.messageId!);
//         // if date is improperly formatted then format it right
//         // the bellow date format will be like 5th May converter
//         DateTime createdAt;
//         try {
//           createdAt = DateTime.parse(conversation.createdAt!);
//         } on FormatException {
//           /// in case it fail to format set fake date
//           createdAt = DateTime.now();
//         }
//         conversation.createdAt = createdAt.toIso8601String();
//         conversation.avatar = HtmlUnescape().convert(conversation.avatar ?? "");
//         if (localConversation == null) {
//           conversation.businessPhoneNumber =
//               conversation.businessPhoneNumber == null
//                   ? ProxyService.box.getUserPhone()!.replaceAll("+", "")
//                   : conversation.businessPhoneNumber;
//           await create(data: conversation);
//         }
//       }

//       if (jsonDecode(response.body)['lastEvaluatedKey'] != null) {
//         /// Set lastKey to the value returned by the API
//         String createdAt = jsonDecode(response.body)['lastEvaluatedKey']
//             ['createdAt'] as String;
//         int id = jsonDecode(response.body)['lastEvaluatedKey']['id'] as int;
//         ProxyService.box.writeString(key: 'createdAt', value: createdAt);
//         ProxyService.box.writeInt(key: 'id', value: id);
//       } else {
//         log(jsonDecode(response.body).toString());
//         log("there is no last key to use in query and that is fine!");
//       }
//     } else {
//       print(response.statusCode);
//     }
//   }

//   @override
//   Future<bool> updateContact(
//       {required Map<String, dynamic> contact, required int businessId}) async {
//     final response = await flipperHttpClient.patch(
//       Uri.parse("$commApi/contacts/${businessId}"),
//       body: jsonEncode(contact),
//     );
//     if (response.statusCode != 200) {
//       return false;
//     }
//     return true;
//   }

//   @override
//   Future<Stock?> addStockToVariant({required Variant variant}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     Stock stock = Stock(
//         lastTouched: DateTime.now(),
//         id: randomNumber(),
//         action: 'create',
//         branchId: branchId,
//         variantId: variant.id!,
//         currentStock: 0.0,
//         productId: variant.productId)
//       ..canTrackingStock = false
//       ..showLowStockAlert = false
//       ..currentStock = 0.0
//       ..branchId = branchId
//       ..variantId = variant.id!
//       ..supplyPrice = 0.0
//       ..retailPrice = 0.0
//       ..lowStock = 10.0 // default static
//       ..canTrackingStock = true
//       ..showLowStockAlert = true
//       ..active = false
//       ..productId = variant.productId
//       ..rsdQty = 0.0;

//     isar.writeTxn(() async {
//       isar.stocks.onPut(stock);
//     });
//     return isar.stocks.get(stock.id!);
//   }

//   @override
//   Future<Conversation> sendMessage(
//       {required String message,
//       required Conversation latestConversation}) async {
//     final reply = Conversation(
//       avatar: "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png",
//       body: message,
//       channelType: "whatsapp",

//       /// always from number is the user phone number i.e the business phone number
//       /// this number need to be enabled on whatsapp business to use whatsapp api
//       fromNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),

//       /// the phone number of a user who sent the message to the business, this is the number
//       /// and this does not have to be registered on flipper but check to see if this from is not us
//       toNumber: latestConversation.fromNumber,
//       userName: latestConversation.userName,
//       messageId: latestConversation.messageId,
//       conversationId: latestConversation.conversationId,
//       phoneNumberId: latestConversation.phoneNumberId,
//       delivered: false,
//       createdAt: DateTime.now().toString(),
//       // now add 5 seconds to the current time
//       scheduledAt: DateTime.now().add(const Duration(seconds: 5)),
//       businessPhoneNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
//       messageType: "text",
//       businessId: ProxyService.box.getBusinessId()!,
//     );
//     return await create(data: reply) as Conversation;
//   }

//   @override
//   Future<EBM?> getEbmByBranchId({required int branchId}) async {
//     return await isar.eBMs.filter().branchIdEqualTo(branchId).findFirst();
//   }

//   /// Retrieves unsynced data from the local database for the current branch.
//   ///
//   /// Returns a map containing unsynced lists for stocks, variants, products,
//   /// favorites, devices, transactions, and transaction items. Filters for entities
//   /// that have been created, updated, or deleted since last sync.
//   @override
//   Future<
//       ({
//         List<Stock> stocks,
//         List<Variant> variants,
//         List<Product> products,
//         List<Favorite> favorites,
//         List<Device> devices,
//         List<ITransaction> transactions,
//         List<TransactionItem> transactionItems
//       })> getUnSyncedData() async {
//     final List<Stock> stocks = await isar.stocks
//         .filter()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .and()
//         .actionIsNotEmpty()
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findAll();
//     final List<Variant> variants = await isar.variants
//         .filter()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findAll();
//     final List<Product> products = await isar.products
//         .filter()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findAll();
//     final List<Favorite> favorites = await isar.favorites
//         .filter()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findAll();
//     final List<Device> devices = await isar.devices
//         .filter()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findAll();
//     final List<ITransaction> transactions = await isar.iTransactions
//         .filter()
//         .statusEqualTo(COMPLETE)
//         .or()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findAll();
//     final List<TransactionItem> transactionItems = await isar.transactionItems
//         .filter()
//         .doneWithTransactionEqualTo(true)
//         .or()
//         .actionEqualTo(AppActions.updated)
//         .or()
//         .actionEqualTo(AppActions.created)
//         .or()
//         .actionEqualTo(AppActions.deleted)
//         .findAll();

//     return (
//       stocks: stocks,
//       variants: variants,
//       products: products,
//       favorites: favorites,
//       devices: devices,
//       transactions: transactions,
//       transactionItems: transactionItems
//     );
//   }

//   /// App Streams should not be overused... streams should be defined between these comments
//   @override
//   Stream<Social> socialsStream({required int branchId}) {
//     log("socialsStream called", name: "${branchId}");
//     return isar.socials
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .isAccountSetEqualTo(true)
//         .watch(fireImmediately: true)
//         .asyncMap((event) => event.first);
//   }

//   /// Retrieves a list of transactions from the database based on the provided filters.
//   ///
//   /// Status, transaction type, and branch ID can be optionally filtered. Cash out transactions can be isolated.
//   /// Pending transactions can optionally be included.
//   ///
//   /// The filtered query is executed against the database and the matching transactions are returned.
//   @override
//   Future<List<ITransaction>> transactionsFuture({
//     String? status,
//     String? transactionType,
//     int? branchId,
//     bool isCashOut = false,
//     bool includePending = false,
//   }) async {
//     final isarQuery =
//         isar.iTransactions.filter().statusEqualTo(status ?? COMPLETE);

//     if (isCashOut) {
//       isarQuery.and().transactionTypeEqualTo(TransactionType.cashOut);
//     } else {
//       isarQuery
//           .and()
//           .transactionTypeEqualTo(TransactionType.cashIn)
//           .or()
//           .transactionTypeEqualTo(TransactionType.sale)
//           .or()
//           .transactionTypeEqualTo(TransactionType.custom)
//           .or()
//           .transactionTypeEqualTo(TransactionType.onlineSale);
//     }

//     if (branchId != null) {
//       isarQuery.and().branchIdEqualTo(branchId);
//     } else {
//       branchId = ProxyService.box.getBranchId()!;
//       isarQuery.and().branchIdEqualTo(branchId);
//     }

//     final transactions = await isarQuery.and().deletedAtIsNull().findAll();

//     return transactions;
//   }

//   @override
//   Stream<List<ITransaction>> transactionsStream({
//     String? status,
//     String? transactionType,
//     int? branchId,
//     bool isCashOut = false,
//     bool includePending = false,
//   }) {
//     final isarQuery =
//         isar.iTransactions.filter().statusEqualTo(status ?? COMPLETE);

//     if (isCashOut) {
//       isarQuery.and().transactionTypeEqualTo(TransactionType.cashOut);
//     } else {
//       isarQuery
//           .or()
//           .transactionTypeEqualTo(TransactionType.cashIn)
//           .or()
//           .transactionTypeEqualTo(TransactionType.sale)
//           .or()
//           .transactionTypeEqualTo(TransactionType.custom)
//           .or()
//           .transactionTypeEqualTo(TransactionType.onlineSale);
//     }

//     if (branchId != null) {
//       isarQuery.and().branchIdEqualTo(branchId);
//     } else {
//       branchId = ProxyService.box.getBranchId()!;
//       isarQuery.and().branchIdEqualTo(branchId);
//     }

//     return isarQuery.and().deletedAtIsNull().watch(fireImmediately: true);
//   }

//   @override
//   Future<List<TransactionItem>> transactionItems(
//       {required int transactionId,
//       required bool doneWithTransaction,
//       required bool active}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     return await isar.transactionItems
//         .filter()
//         .transactionIdEqualTo(transactionId)
//         // .and()
//         .doneWithTransactionEqualTo(doneWithTransaction)
//         // .and()
//         .branchIdEqualTo(branchId)
//         // .and()
//         .deletedAtIsNull()
//         // .and()
//         .activeEqualTo(active)
//         .findAll();
//   }

//   @override
//   Stream<List<ITransaction>> getTransactionsByCustomerId(
//       {required int customerId}) async* {
//     yield* isar.iTransactions
//         .filter()
//         .customerIdEqualTo(customerId)
//         .watch(fireImmediately: true);
//   }

//   @override
//   Future<List<Device>> getDevices({required int businessId}) async {
//     // get device from isar with linking code and return it
//     return await isar.devices
//         .filter()
//         .businessIdEqualTo(businessId)
//         // .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   @override
//   Stream<List<Conversation>> getTop5RecentConversations() {
//     if (ProxyService.box.getUserPhone() == null) return Stream.empty();
//     final phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
//     log(phone, name: "top5Conversations");

//     return isar.conversations
//         .filter()
//         .toNumberEqualTo(phone)
//         .or()
//         .fromNumberEqualTo(phone)
//         // .and()
//         .deliveredEqualTo(true)
//         .sortByCreatedAtDesc()
//         .watch(fireImmediately: true)
//         .map((event) {
//       final uniqueUserNames = <String>{};
//       final uniqueConversations = <Conversation>[];

//       for (final message in event) {
//         if (!uniqueUserNames.contains(message.userName)) {
//           uniqueUserNames.add(message.userName);
//           uniqueConversations.add(message);
//         }
//       }

//       // Sort conversations by creation date in descending order
//       uniqueConversations.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

//       // Return the top 5 recent conversations
//       return uniqueConversations.take(5).toList();
//     });
//   }

//   @override
//   Stream<List<Conversation>> conversations({String? conversationId}) {
//     if (conversationId == null && ProxyService.box.getUserPhone() != null) {
//       // get all conversations addressed to me or from me
//       String phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
//       log(phone, name: "LoadInitialList of conversations");

//       return isar.conversations
//           .filter()
//           .toNumberEqualTo(phone)
//           // .or()
//           .fromNumberEqualTo(phone)
//           // .and()
//           .deliveredEqualTo(true)
//           .watch(fireImmediately: true)
//           .asyncMap((event) {
//         final uniqueUserNames = <String>{};
//         final uniqueConversations = <Conversation>[];

//         for (final message in event) {
//           if (!uniqueUserNames.contains(message.userName)) {
//             uniqueUserNames.add(message.userName);
//             uniqueConversations.add(message);
//           }
//         }

//         return uniqueConversations;
//       });
//     } else {
//       return isar.conversations
//           .filter()
//           .conversationIdEqualTo(conversationId)
//           .watch(fireImmediately: true);
//     }
//   }

//   @override
//   Stream<List<ITransaction>> ticketsStreams() {
//     log(ProxyService.box.getBranchId()!.toString(), name: "ticketsStreams()");
//     return isar.iTransactions
//         .filter()
//         .statusEqualTo(PARKED)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .watch(fireImmediately: true);
//   }

//   Future<void> assignStockToVariant({required int variantId}) async {
//     Variant? variant = await isar.variants.get(variantId);

//     Stock? stock = await isar.stocks
//         .filter()
//         .variantIdEqualTo(variantId)
//         .and()
//         .branchIdEqualTo(ProxyService.box.getBranchId()!)
//         .findFirst();
//     if (stock == null) {
//       isar.stocks.onPut(
//         Stock(
//             lastTouched: DateTime.now(),
//             id: randomNumber(),
//             action: 'create',
//             branchId: ProxyService.box.getBranchId()!,
//             variantId: variantId,
//             currentStock: 0.0,
//             productId: variant!.productId),
//       );
//     }
//   }

//   @override
//   Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
//     return isar.favorites
//         .filter()
//         .favIndexEqualTo(favIndex)
//         .deletedAtIsNull()
//         .watch(fireImmediately: true)
//         .asyncMap((event) => event.first);
//   }

//   @override
//   Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
//     int branchId = ProxyService.box.getBranchId()!;
//     return isar.variants
//         .filter()
//         .productIdEqualTo(productId)
//         .and()
//         .deletedAtIsNull()
//         .and()
//         .branchIdEqualTo(branchId)
//         .sortByLastTouchedDesc()
//         .watch(fireImmediately: true);
//   }

//   @override
//   Future<List<Product>> getProductList({int? prodIndex}) async {
//     int branchId = ProxyService.box.getBranchId()!;

//     final completer = Completer<List<Product>>();
//     final queryBuilder = isar.products
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull();

//     if (prodIndex != null) {
//       queryBuilder.idEqualTo(prodIndex);
//     }

//     final products = await queryBuilder.findAll();

//     completer.complete(products);
//     return completer.future;
//   }

//   @override
//   Stream<List<Product>> productStreams({int? prodIndex}) {
//     int branchId = ProxyService.box.getBranchId()!;
//     if (prodIndex == null) {
//       return isar.products
//           .filter()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .watch(fireImmediately: true);
//     } else {
//       return isar.products
//           .filter()
//           .branchIdEqualTo(branchId)
//           .and()
//           .deletedAtIsNull()
//           .and()
//           .idEqualTo(prodIndex)
//           .watch(fireImmediately: true);
//     }
//   }

//   @override
//   Future<Customer?> getCustomer({String? key, int? id}) async {
//     if (key != null && id != null) {
//       throw ArgumentError(
//           'Cannot provide both a key and an id at the same time');
//     }
//     if (id != null) {
//       return await isar.customers.get(id);
//     } else if (key != null) {
//       final customer = await isar.customers
//           .filter()
//           .custNmContains(key)
//           .or()
//           .emailContains(key)
//           .or()
//           .telNoContains(key)
//           .and()
//           .deletedAtIsNull()
//           .findFirst();
//       return customer;
//     } else {
//       return null;
//     }
//   }

//   Future<bool> hasNoActivityInLast5Minutes(
//       {required int userId, int? refreshRate = 5}) async {
//     // Get the current time
//     DateTime currentTime = DateTime.now();

//     // Calculate the time [timer] minutes ago
//     DateTime fiveMinutesAgo =
//         currentTime.subtract(Duration(minutes: refreshRate!));

//     // Retrieve the user activities
//     List<UserActivity> userActivities = await activities(userId: userId);

//     // Assume no activity in the last 5 minutes by default
//     bool returnValue = true;

//     for (var activity in userActivities) {
//       if (activity.lastTouched!.isAfter(fiveMinutesAgo)) {
//         // The user has done an activity within the last 5 minutes
//         returnValue = false;
//         break; // No need to continue checking, we found an activity
//       }
//     }
//     return returnValue;
//   }

//   @override
//   Stream<IITenant?> authState({required int branchId}) {
//     int userId = ProxyService.box.getUserId()!;
//     return isar.iITenants
//         .filter()
//         .userIdEqualTo(userId)
//         .deletedAtIsNull()
//         .sortByLastTouchedDesc()
//         .watch(fireImmediately: true)
//         .asyncMap((event) => event.first);
//   }

//   @override
//   Future<void> refreshSession(
//       {required int branchId, int? refreshRate = 5}) async {
//     while (true) {
//       try {
//         int userId = ProxyService.box.getUserId()!;
//         bool noActivity = await hasNoActivityInLast5Minutes(
//             userId: userId, refreshRate: refreshRate);
//         log(noActivity.toString(), name: 'session');
//         log(userId.toString(), name: 'session');
//         if (noActivity) {
//           IITenant? tenant =
//               await getTenantBYUserId(userId: ProxyService.box.getUserId()!);
//           tenant?.sessionActive = false;
//           update(data: tenant);
//         }
//       } catch (error) {
//         print('Error fetching tenant: $error');
//       }
//       await Future.delayed(Duration(minutes: refreshRate!));
//     }
//   }

//   @override
//   Future<List<UserActivity>> activities({required int userId}) async {
//     // Get the current date
//     DateTime now = DateTime.now();

//     // Calculate the start and end of the current day
//     DateTime startOfDay = DateTime(now.year, now.month, now.day);
//     DateTime endOfDay = startOfDay.add(Duration(days: 1));

//     return await isar.userActivitys
//         .filter()
//         .lastTouchedBetween(startOfDay, endOfDay)
//         .findAll();
//   }

//   @override
//   Future<void> recordUserActivity(
//       {required int userId, required String activity}) async {
//     isar.writeTxn(() async => isar.userActivitys.put(UserActivity(
//         userId: userId,
//         action: activity,
//         id: randomNumber(),
//         timestamp: DateTime.now(),
//         lastTouched: DateTime.now())));
//   }

//   /// there is cases where singup fail and there is some variable saved
//   /// in this case for us to be clean better clean them for next attempt
//   @override
//   Future<void> logOutLight() async {
//     ProxyService.box.remove(key: 'userId');
//     ProxyService.box.remove(key: 'getIsTokenRegistered');
//     ProxyService.box.remove(key: 'bearerToken');
//     ProxyService.box.remove(key: 'branchId');
//     ProxyService.box.remove(key: 'userPhone');
//     ProxyService.box.remove(key: 'UToken');
//     ProxyService.box.remove(key: 'businessId');
//     ProxyService.box.remove(key: 'defaultApp');
//   }

//   //  @override
//   ///TODO: @Richard add flag from backend to define if tenant is default
//   @override
//   Stream<IITenant?> getDefaultTenant({required int businessId}) {
//     return isar.iITenants
//         .filter()
//         .businessIdEqualTo(businessId)
//         .deletedAtIsNull()
//         .watch(fireImmediately: true)
//         .asyncMap((event) => event.first);
//   }

//   @override
//   Future<List<Customer>> customers({required int branchId}) async {
//     return await isar.customers
//         .filter()
//         .branchIdEqualTo(branchId)
//         .and()
//         .deletedAtIsNull()
//         .findAll();
//   }

//   @override
//   Future<List<SyncRecord>> syncedModels({required int branchId}) async {
//     return await isar.syncRecords.filter().branchIdEqualTo(branchId).findAll();
//   }

//   List<ITransaction> findAndFilter(
//       List<ITransaction> transactions, int branchId) {
//     return transactions
//         .where((transaction) => transaction.supplierId == branchId)
//         .toList();
//   }

//   @override
//   Stream<List<ITransaction>> orders({required int branchId}) {
//     return isar.iTransactions
//         .filter()
//         .statusEqualTo(PENDING)
//         .watch(fireImmediately: true)
//         .map((transactions) => findAndFilter(transactions, branchId));
//   }

//   @override
//   Future<Product?> getProductByBarCode({required String barCode}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     return await isar.products
//         .filter()
//         .barCodeEqualTo(barCode)
//         .and()
//         .deletedAtIsNull()
//         .and()
//         .branchIdEqualTo(branchId)
//         .findFirst();
//   }

//   @override
//   Future<List<Product?>> getProductByName({required String name}) async {
//     int branchId = ProxyService.box.getBranchId()!;
//     return await isar.products
//         .filter()
//         .nameStartsWith(name, caseSensitive: false)
//         .or()
//         .nameContains(name, caseSensitive: false)
//         .or()
//         .nameEndsWith(name, caseSensitive: false)
//         .and()
//         .deletedAtIsNull()
//         .and()
//         .branchIdEqualTo(branchId)
//         .findAll();
//   }

//   @override
//   Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
//     return isar.variants
//         .filter()
//         .productIdEqualTo(productId ?? 0)
//         .and()
//         .deletedAtIsNull()
//         .watch(fireImmediately: true);
//   }

//   @override
//   Future<Branch> activeBranch() async {
//     return await isar.iBranchs.filter().isDefaultEqualTo(true).findFirst();
//   }

//   @override
//   Future<IPermission?> permission({required int userId}) async {
//     return await isar.iPermissions.filter().userIdEqualTo(userId).findFirst();
//   }

//   @override
//   Future assignCustomerToTransaction(
//       {required int customerId, int? transactionId}) async {
//     // Update transaction
//     isar.writeTxn(() async {
//       final transaction = await isar.iTransactions.get(transactionId ?? 0);
//       if (transaction != null) {
//         transaction.customerId = customerId;
//         isar.iTransactions.put(transaction);
//       }
//     });

//     // Update customer
//     isar.writeTxn(() async {
//       final customer = await isar.customers.get(customerId);
//       if (customer != null) {
//         customer.updatedAt = DateTime.now();
//         isar.customers.put(customer);
//       }
//     });
//   }

//   /// given a transactionId and a customer, remove the given customer from the
//   /// given transaction
//   @override
//   Future removeCustomerFromTransaction(
//       {required int customerId, required int transactionId}) async {
//     // get transaction where id = transactionId from isar
//     ITransaction? transaction = await isar.iTransactions
//         .filter()
//         .idEqualTo(transactionId)
//         .and()
//         .customerIdEqualTo(customerId)
//         .findFirst();
//     // remove customerId from the transaction and set it to null
//     transaction?.customerId = null;
//     // update transaction to isar
//     if (transaction != null) {
//       isar.writeTxn(() async {
//         isar.iTransactions.onPut(transaction);
//       });
//     }
//   }

//   @override
//   Stream<List<ITransaction>> transactionList(
//       {DateTime? startDate, DateTime? endDate}) {
//     if (startDate == null || endDate == null) return Stream.empty();
//     final transactionCollection = isar.iTransactions
//         .filter()
//         .statusEqualTo(COMPLETE)
//         .lastTouchedBetween(startDate, endDate)
//         .watch(fireImmediately: true);

//     return transactionCollection;
//   }

//   @override
//   String dbPath() {
//     // TODO: implement dbPath
//     throw UnimplementedError();
//   }
// }
