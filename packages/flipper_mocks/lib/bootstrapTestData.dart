// save them in realm db
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

class CreateMockdata {
  Future<void> mockBusiness() async {
    await ProxyService.strategy.create<Business>(data: businessMock);
  }

  Future<void> mockTransactions() async {
    for (var i = 0; i < 1000; i++) {
      await ProxyService.strategy.create<ITransaction>(
        data: ITransaction(
          lastTouched: DateTime(2023, 10, 28),
          supplierId: 1,
          reference: "2333",
          transactionNumber: "3333",
          status: COMPLETE,
          transactionType: 'local',
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime(2023, 10, 28),
          customerChangeDue: 0.0,
          paymentType: "Cash",
          branchId: 1,
          createdAt: DateTime(2023, 10, 28),
          receiptType: "Standard",
          customerId: "101",
          customerType: "Regular",
          note: "Initial transaction",
          ebmSynced: false,
          isIncome: true,
          isExpense: false,
          isRefunded: false,
        ),
      );
    }
  }

  Future<void> createAndSaveMockStockRequests() async {
    // Create a product first
    Product? product = await ProxyService.strategy.createProduct(
        createItemCode: true,
        bhFId: "00",
        tinNumber: 111,
        branchId: 1,
        businessId: 1,
        qty: 100,
        product: Product(
            name: "Test Product",
            color: "#ccc",
            businessId: 1,
            branchId: 1,
            isComposite: true,
            nfcEnabled: false));

    if (product != null) {
      // Query for the variant
      var variants = await ProxyService.strategy
          .variants(productId: product.id, branchId: 1);
      var variant = variants.isNotEmpty ? variants.first : null;

      final mockStockRequests = [
        InventoryRequest(
          branchId: "",
          financingId: "",
          mainBranchId: 1,
          subBranchId: 2,
          status: 'pending',
          transactionItems: [
            TransactionItem(
              itemTyCd: "",
              pkgUnitCd: "",
              qtyUnitCd: "",
              itemCd: "",
              lastTouched: DateTime.now().toUtc(),
              itemNm: "itemNm",
              price: 100,
              inventoryRequestId: "",
              discount: 10,
              prc: 10,
              name: product.name,
              quantityRequested: 1,
              qty: 5,
              variantId: variant?.id,
            ),
          ],
        ),
        InventoryRequest(
          branchId: "",
          financingId: "",
          mainBranchId: 1,
          subBranchId: 2,
          status: 'pending',
          transactionItems: [
            TransactionItem(
              itemTyCd: "",
              pkgUnitCd: "",
              qtyUnitCd: "",
              itemCd: "",
              inventoryRequestId: "",
              lastTouched: DateTime.now().toUtc(),
              itemNm: "itemNm",
              price: 100,
              discount: 10,
              prc: 10,
              quantityRequested: 1,
              name: product.name,
              qty: 3,
              variantId: variant?.id,
            ),
          ],
        ),
      ];

      for (var stockRequest in mockStockRequests) {
        await ProxyService.strategy
            .create<InventoryRequest>(data: stockRequest);
      }
    }
  }
}
