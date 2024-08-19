// save them in realm db
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';

Future<void> createAndSaveMockStockRequests({required Realm realm}) async {
  // Create a product first
  Product? product = await ProxyService.realm.createProduct(
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
