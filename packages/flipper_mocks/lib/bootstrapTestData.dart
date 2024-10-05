// save them in realm db
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';

class CreateMockdata {
  void mockBusiness({required Realm local}) {
    local.write(() {
      local.add<Business>(businessMock);
    });
  }

  void mockTransactions({required Realm realm}) {
    for (var i = 0; i < 1000; i++) {
      realm.write(() {
        realm.add<ITransaction>(ITransaction(
          ObjectId(),
          lastTouched: DateTime(2023, 10, 28),
          id: randomNumber(),
          supplierId: 1,
          reference: "2333",
          transactionNumber: "3333",
          status: COMPLETE,
          transactionType: 'local',
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime(2023, 10, 28).toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: 1,
          createdAt: DateTime(2023, 10, 28).toIso8601String(),
          receiptType: "Standard",
          customerId: 101,
          customerType: "Regular",
          note: "Initial transaction",
          deletedAt: null,
          ebmSynced: false,
          isIncome: true,
          isExpense: false,
          isRefunded: false,
        ));
      });
    }
  }

  Future<void> ensureRealmInitialized() async {
    if (ProxyService.box.encryptionKey().isNotEmpty &&
        ProxyService.local.realm == null) {
      await ProxyService.local.configureLocal(useInMemory: false);
    }
  }

  Future<void> createAndSaveMockStockRequests({required Realm realm}) async {
    // Create a product first
    Product? product = await ProxyService.local.createProduct(
        bhFId: "00",
        tinNumber: 111,
        branchId: 1,
        businessId: 1,
        product: Product(ObjectId(),
            name: "Test Product",
            color: "#ccc",
            id: randomNumber(),
            businessId: 1,
            branchId: 1,
            isComposite: true,
            nfcEnabled: false));

    if (product != null) {
      // Query for the variant
      var variants = realm.query<Variant>(r'productId == $0', [product.id]);
      var variant = variants.isNotEmpty ? variants.first : null;
      realm.write(() {
        for (var variant in variants) {
          // Create Stock for each Variant
          Stock stock = Stock(
            ObjectId(),
            variantId: variant.id,
            currentStock: 100,
            branchId: 1,
            variant: variant,
            rsdQty: 100,
          );
          realm.add(stock);
        }
      });
      final mockStockRequests = [
        StockRequest(
          ObjectId(),
          id: randomNumber(),
          mainBranchId: 1,
          subBranchId: 2,
          status: 'pending',
          items: [
            TransactionItem(
              ObjectId(),
              name: product.name,
              quantityRequested: 1,
              qty: 5,
              variantId: variant?.id ?? 0,
            ),
          ],
        ),
        StockRequest(
          ObjectId(),
          id: randomNumber(),
          mainBranchId: 1,
          subBranchId: 2,
          status: 'pending',
          items: [
            TransactionItem(
              ObjectId(),
              quantityRequested: 1,
              name: product.name,
              qty: 3,
              variantId: variant?.id ?? 0,
            ),
          ],
        ),
      ];

      realm.write(() {
        for (var stockRequest in mockStockRequests) {
          realm.add(stockRequest);
        }
      });
    }
  }
}
