import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/brick.g.dart';
import 'package:brick_supabase/src/supabase_provider.dart';
import 'package:test/test.dart';
import 'package:brick_supabase/testing.dart';
import 'package:uuid/uuid.dart';

void main() {
  final mock = SupabaseMockServer(modelDictionary: supabaseModelDictionary);
  group('Purchase with Variants', () {
    setUp(mock.setUp);
    tearDown(mock.tearDown);

    test('#getPurchaseWithVariants', () async {
      // Create mock Variant data
      final variant1 = Variant(
        id: const Uuid().v4(),
        name: 'Variant 1',
        purchaseId: '1', // Link to the Purchase
        taxPercentage: 18.0,
      );
      final variant2 = Variant(
        id: const Uuid().v4(),
        name: 'Variant 2',
        purchaseId: '1', // Link to the Purchase
        taxPercentage: 18.0,
      );

      // Create mock Purchase data with Variants
      final purchase = Purchase(
        branchId: 1,
        id: '1',
        spplrTin: '123456789',
        spplrNm: 'Supplier Name',
        spplrBhfId: 'BH123',
        spplrInvcNo: 1001,
        rcptTyCd: 'RCPT001',
        pmtTyCd: 'PMT001',
        cfmDt: '2023-10-01',
        salesDt: '2023-10-01',
        totItemCnt: 2,
        taxblAmtA: 100.0,
        taxblAmtB: 200.0,
        taxblAmtC: 300.0,
        taxblAmtD: 400.0,
        taxRtA: 10.0,
        taxRtB: 20.0,
        taxRtC: 30.0,
        taxRtD: 40.0,
        taxAmtA: 10.0,
        taxAmtB: 40.0,
        taxAmtC: 90.0,
        taxAmtD: 160.0,
        totTaxblAmt: 1000.0,
        totTaxAmt: 300.0,
        totAmt: 1300.0,
        variants: [variant1, variant2], // Include Variants in the Purchase
      );

      // Mock Supabase request and response
      final req = SupabaseRequest<Purchase>();
      final resp = SupabaseResponse([
        await mock.serialize(purchase),
      ]);

      // Stub the server with the mock data
      mock.handle({req: resp});

      // Initialize the provider
      final provider = SupabaseProvider(mock.client,
          modelDictionary: supabaseModelDictionary);

      // Retrieve the Purchase
      final retrieved = await provider.get<Purchase>();

      // Assertions
      expect(retrieved, hasLength(1)); // Ensure one Purchase is returned
      expect(
          retrieved.first.variants, isNotNull); // Ensure Variants are not null
      expect(retrieved.first.variants,
          hasLength(2)); // Ensure there are 2 Variants
      expect(retrieved.first.variants?.first.name,
          'Variant 1'); // Check Variant data
      expect(retrieved.first.variants?.last.name,
          'Variant 2'); // Check Variant data
    });
  });
  group('Isar Realm API!', () {
    CoreSync realm = CoreSync();
    setUp(mock.setUp);

    setUpAll(() async {
      // Initialize the Realm API with an in-memory database for testing
      // await realm.configureLocal(useInMemory: true, box: ProxyService.box);
    });

    tearDownAll(() async {});
    setUp(() async {
      // realm.realm!.write(() {
      //   realm.realm!.deleteAll<Product>();
      //   realm.realm!.deleteAll<SKU>();
      //   realm.realm!.deleteAll<Variant>();
      // });
    });

    test('Add product into realm db', () async {
      Product? product = await realm.createProduct(
          createItemCode: true,
          bhFId: "00",
          tinNumber: 111,
          branchId: 1,
          businessId: 1,
          product: Product(
              name: "Test Product",
              color: "#ccc",
              businessId: 1,
              branchId: 1,
              isComposite: true,
              nfcEnabled: false));

      expect(product, isA<Product>());
    });

    //   test('Ensure unique SKUs for variants created with products', () async {
    //     const int numberOfProducts = 5;
    //     final skuSet = <String>{}; // Set to store unique SKUs

    //     // Add multiple products
    //     for (int i = 0; i < numberOfProducts; i++) {
    //       await realm.createProduct(
    //           bhFId: "00",
    //           tinNumber: 111,
    //           branchId: 1,
    //           businessId: 1,
    //           product: Product(
    //               name: "Product $i",
    //               color: "#ccc",
    //
    //               businessId: 1,
    //               branchId: 1,
    //               isComposite: true,
    //               nfcEnabled: false));
    //     }

    //     // Query all variants to check SKUs
    //     final variants =
    //         realm.realm!.query<Variant>(r'branchId == $0', [1]).toList();
    //     for (var variant in variants) {
    //       if (skuSet.contains(variant.sku)) {
    //         fail('Duplicate SKU found: ${variant.sku}');
    //       }
    //       skuSet.add(variant.sku!);
    //     }

    //     expect(skuSet.length, numberOfProducts * 1,
    //         reason: 'Not all SKUs are unique');
    //   });
  });
}
