import 'dart:async';
import 'dart:math';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin ProductMixin implements ProductInterface {
  Repository get repository;

  @override
  Future<List<Product>> products({required int branchId}) async {
    return await repository.get<Product>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
    if (prodIndex != null) {
      return repository
          .get<Product>(
            query: Query(where: [Where('id').isExactly(prodIndex)]),
          )
          .asStream();
    }
    return repository.get<Product>().asStream();
  }

  @override
  Future<double> totalStock({String? productId, String? variantId}) async {
    double totalStock = 0.0;
    if (productId != null) {
      List<Stock> stocksIn = await repository.get<Stock>(
          query: Query(where: [Where('productId').isExactly(productId)]));
      totalStock =
          stocksIn.fold(0.0, (sum, stock) => sum + (stock.currentStock!));
    } else if (variantId != null) {
      List<Stock> stocksIn = await repository.get<Stock>(
          query: Query(where: [Where('variantId').isExactly(variantId)]));
      totalStock =
          stocksIn.fold(0.0, (sum, stock) => sum + (stock.currentStock!));
    }
    return totalStock;
  }

  @override
  Stream<double> wholeStockValue({required int branchId}) async* {
    final products = await repository.get<Product>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );

    double totalValue = 0;
    for (var product in products) {
      final variants = await repository.get<Variant>(
        query: Query(where: [Where('productId').isExactly(product.id)]),
      );
      for (var variant in variants) {
        totalValue += (variant.quantity ?? 0) * (variant.retailPrice ?? 0);
      }
    }
    yield totalValue;
  }

  @override
  Future<Product?> getProduct(
      {String? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId}) async {
    return (await repository.get<Product>(
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
            query: Query(where: [
              if (id != null) Where('id').isExactly(id),
              if (name != null) Where('name').isExactly(name),
              if (barCode != null) Where('barCode').isExactly(barCode),
              Where('branchId').isExactly(branchId),
              Where('businessId').isExactly(businessId),
            ])))
        .firstOrNull;
  }

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      String? modrId,
      String? orgnNatCd,
      String? exptNatCd,
      int? pkg,
      String? pkgUnitCd,
      String? qtyUnitCd,
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
      double? invcFcurExcrt,
      String? dclNo,
      String? taskCd,
      String? dclDe,
      String? hsCd,
      String? imptItemsttsCd,
      String? spplrItemClsCd,
      String? spplrItemCd,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      required bool createItemCode,
      bool ebmSynced = false,
      String? saleListId,
      Purchase? purchase,
      String? pchsSttsCd,
      double? totAmt,
      double? taxAmt,
      double? taxblAmt,
      String? taxTyCd,
      double? splyAmt,
      String? itemCd}) async {
    try {
      final String productName = product.name;
      if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
        final Product? existingProduct = await getProduct(
            name: productName, businessId: businessId, branchId: branchId);
        if (existingProduct != null) {
          return existingProduct;
        }
      }

      SKU sku = await getSku(branchId: branchId, businessId: businessId);

      sku.consumed = true;
      await repository.upsert(sku);
      final createdProduct = await repository.upsert<Product>(product);

      if (!skipRegularVariant) {
        // Check if a variant with the same product and barcode already exists
        final queryConditions = [
          brick.Where('productId').isExactly(createdProduct.id),
        ];

        if (product.barCode?.isNotEmpty == true) {
          queryConditions.add(brick.Where('bcd').isExactly(product.barCode!));
        }

        final existingVariants = await repository.get<Variant>(
          query: brick.Query(where: queryConditions),
        );

        // If a variant with the same product and barcode exists, return the product
        if (existingVariants.isNotEmpty) {
          talker.info(
              'Variant already exists with ID: ${existingVariants.first.id}');
          return createdProduct;
        }

        Variant newVariant = await _createRegularVariant(
          branchId,
          tinNumber,
          orgnNatCd: orgnNatCd,
          exptNatCd: exptNatCd,
          pchsSttsCd: pchsSttsCd,
          pkg: pkg,
          taxblAmt: taxblAmt,
          taxAmt: taxAmt,
          totAmt: totAmt,
          itemCd: itemCd,
          createItemCode: createItemCode,
          taxTypes: taxTypes,
          saleListId: saleListId,
          itemClasses: itemClasses,
          itemTypes: itemTypes,
          pkgUnitCd: pkgUnitCd,
          qtyUnitCd: qtyUnitCd,
          totWt: totWt,
          netWt: netWt,
          spplrNm: spplrNm,
          agntNm: agntNm,
          invcFcurAmt: invcFcurAmt,
          invcFcurExcrt: invcFcurExcrt,
          invcFcurCd: invcFcurCd,
          qty: qty,
          dclNo: dclNo,
          taskCd: taskCd,
          dclDe: dclDe,
          hsCd: hsCd,
          imptItemsttsCd: imptItemsttsCd,
          product: createdProduct,
          bhFId: bhFId,
          supplierPrice: supplyPrice,
          retailPrice: retailPrice,
          name: createdProduct.name,
          sku: sku.sku!,
          productId: product.id,
          itemSeq: itemSeq,
          bcd: product.barCode,
          ebmSynced: ebmSynced,
          spplrItemCd: spplrItemCd,
          taxTyCd: taxTyCd,
          splyAmt: splyAmt,
          spplrItemClsCd: spplrItemClsCd,
        );
        talker.info('New variant created: ${newVariant.toFlipperJson()}');
        // Create and save the stock first
        final stock = Stock(
          id: const Uuid().v4(),
          lastTouched: DateTime.now().toUtc(),
          rsdQty: qty,
          initialStock: qty,
          value:
              (qty * (retailPrice > 0 ? retailPrice : supplyPrice)).toDouble(),
          branchId: branchId,
          currentStock: qty,
        );

        // Save stock first and get the created instance
        final createdStock = await repository.upsert<Stock>(stock);
        talker.info('Created stock: ${createdStock.id} for variant');

        // Set stock reference on variant
        newVariant.stock = createdStock;
        newVariant.stockId = createdStock.id;
        newVariant.ebmSynced =
            false; // Ensure this is set to false to trigger EBM sync

        // Save the variant with the stock reference
        final savedVariant = await repository.upsert<Variant>(newVariant);

        // Verify the stock was saved correctly
        if (savedVariant.stockId == null || savedVariant.stockId!.isEmpty) {
          throw Exception('Failed to assign stock to variant');
        }

        talker.info(
            'Variant ${savedVariant.id} created with stock ${savedVariant.stockId}');

        // Refresh the variant to ensure we have the latest data
        final refreshedVariants = await repository.get<Variant>(
          query: brick.Query(
              where: [brick.Where('id').isExactly(savedVariant.id)]),
        );

        if (refreshedVariants.isEmpty) {
          throw Exception('Failed to retrieve saved variant');
        }

        final refreshedVariant = refreshedVariants.first;
        if (refreshedVariant.stockId == null) {
          talker.error(
              'Variant ${refreshedVariant.id} has no stockId after save!');
        }

        // If associated with a purchase, update the purchase-variant relationship
        if (purchase != null) {
          // Ensure purchase has a variants list
          if (purchase.variants == null) {
            purchase.variants = [];
          }

          // Check if variant is already associated with this purchase
          final variantExists =
              purchase.variants?.any((v) => v.id == savedVariant.id) ?? false;

          if (!variantExists) {
            // Add the variant to the purchase
            purchase.variants = [...purchase.variants ?? [], savedVariant];

            // Update supplier name on the variant
            savedVariant.spplrNm = purchase.spplrNm;
            savedVariant.purchaseId = purchase.id;

            try {
              // Save both the variant and purchase
              await repository.upsert<Variant>(savedVariant);
              await repository.upsert<Purchase>(purchase);

              talker.info(
                  'Added variant ${savedVariant.id} to purchase ${purchase.id}');
            } catch (e) {
              talker.error('Error saving variant/purchase association: $e');
              rethrow;
            }
          } else {
            talker.info(
                'Variant ${savedVariant.id} already exists in purchase ${purchase.id}');
          }
        }
      }
      if (purchase != null) {
        await repository.upsert<Purchase>(purchase);
      }

      return createdProduct;
    } catch (e) {
      rethrow;
    }
  }

  Future<Variant> _createRegularVariant(int branchId, int? tinNumber,
      {required double qty,
      required double supplierPrice,
      required double retailPrice,
      required int itemSeq,
      String? bhFId,
      bool createItemCode = false,
      required bool ebmSynced,
      Product? product,
      required String productId,
      required String name,
      String? orgnNatCd,
      String? exptNatCd,
      int? pkg,
      String? pkgUnitCd,
      String? qtyUnitCd,
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
      double? invcFcurExcrt,
      String? dclNo,
      String? taskCd,
      String? dclDe,
      String? hsCd,
      String? imptItemsttsCd,
      String? spplrItemCd,
      String? spplrItemClsCd,
      String? categoryId,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      required int sku,
      Configurations? taxType,
      String? bcd,
      String? saleListId,
      String? pchsSttsCd,
      double? totAmt,
      double? taxAmt,
      double? taxblAmt,
      String? itemCd,
      String? taxTyCd,
      double? splyAmt}) async {
    final String variantId = const Uuid().v4();
    final number = randomNumber().toString().substring(0, 5);
    Category? category = (await repository.get<Category>(
      query: Query(where: [Where('id').isExactly(categoryId)]),
    ))
        .firstOrNull;

    return Variant(
      spplrNm: spplrNm ?? "",
      agntNm: agntNm ?? "",
      totAmt: totAmt,
      netWt: netWt ?? 0,
      totWt: totWt ?? 0,
      pchsSttsCd: pchsSttsCd,
      taxblAmt: taxblAmt,
      taxAmt: taxAmt,
      invcFcurAmt: invcFcurAmt ?? 0,
      invcFcurCd: invcFcurCd ?? "",
      exptNatCd: exptNatCd ?? "",
      dclNo: dclNo ?? "",
      taskCd: taskCd ?? "",
      dclDe: dclDe ?? "",
      hsCd: hsCd ?? "",
      imptItemSttsCd: imptItemsttsCd ?? null,
      lastTouched: DateTime.now().toUtc(),
      name: product?.name ?? name,
      sku: sku.toString(),
      dcRt: 0.0,
      productId: product?.id ?? productId,
      categoryId: categoryId,
      categoryName: category?.name,
      color: product?.color,
      unit: 'Per Item',
      productName: product?.name ?? name,
      branchId: branchId,
      supplyPrice: supplierPrice,
      retailPrice: retailPrice,
      id: variantId,
      bhfId: bhFId ?? '00',
      itemStdNm: product?.name ?? name,
      addInfo: "A",
      pkg: pkg ?? 1,
      splyAmt: supplierPrice,
      itemClsCd: itemClasses?[product?.barCode] ?? "5020230602",
      itemCd: createItemCode
          ? await itemCode(
              countryCode: orgnNatCd ?? "RW",
              productType: "2",
              packagingUnit: "CT",
              quantityUnit: "BJ",
              branchId: branchId,
            )
          : itemCd ?? "",
      modrNm: name,
      modrId: number,
      pkgUnitCd: pkgUnitCd ?? "BJ",
      regrId: randomNumber().toString().substring(0, 5),
      itemTyCd: itemTypes?.containsKey(product?.barCode) == true
          ? itemTypes![product!.barCode]!
          : "2", // this is a finished product
      /// available type for itemTyCd are 1 for raw material and 3 for service
      /// is insurance applicable default is not applicable
      isrcAplcbYn: "N",
      useYn: "N",
      itemSeq: itemSeq,
      itemNm: product?.name ?? name,
      taxPercentage: taxType?.taxPercentage ?? 18.0,
      tin: tinNumber,
      bcd: bcd ??
          (product?.name ?? name)
              .substring(0, min((product?.name ?? name).length, 20)),

      /// country of origin for this item we default until we support something different
      /// and this will happen when we do import.
      orgnNatCd: orgnNatCd ?? "RW",

      /// registration name
      regrNm: product?.name ?? name,

      /// taxation type code
      taxTyCd: taxTypes?[product?.barCode] ?? taxTyCd ?? "B",

      // default unit price
      dftPrc: retailPrice,
      prc: retailPrice,

      /// Packaging Unit
      // qtyUnitCd ??
      qtyUnitCd: "U", // see 4.6 in doc
      ebmSynced: ebmSynced,
      spplrItemCd: spplrItemCd ?? "",
      spplrItemClsCd: itemClasses?[product?.barCode] ?? spplrItemClsCd,
      spplrItemNm: product?.name ?? name,
    );
  }

  @override
  FutureOr<String> itemCode(
      {required String countryCode,
      required String productType,
      required packagingUnit,
      required int branchId,
      required String quantityUnit}) async {
    final repository = Repository();
    final query = Query(
      where: [
        Where('code').isNot(null),
        Where('branchId').isExactly(branchId),
      ],
      orderBy: [OrderBy('createdAt', ascending: false)],
    );
    final items = await repository.get<ItemCode>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Extract the last sequence number and increment it
    int lastSequence = 0;
    if (items.isNotEmpty) {
      final lastItemCode = items.first.code;
      final sequencePart = lastItemCode.substring(lastItemCode.length - 7);
      try {
        lastSequence = int.parse(sequencePart);
      } catch (e) {
        lastSequence = 0;
      }
    }
    final newSequence = (lastSequence + 1).toString().padLeft(7, '0');
    // Construct the new item code
    final newItemCode =
        '$countryCode$productType$packagingUnit$quantityUnit$newSequence';

    // Save the new item code in the database
    final newItem = ItemCode(
        code: newItemCode,
        createdAt: DateTime.now().toUtc(),
        branchId: branchId);
    await repository.upsert(newItem);

    return newItemCode;
  }

  @override
  FutureOr<SKU> getSku({required int branchId, required int businessId}) async {
    final query = Query(
      where: [
        Where('branchId').isExactly(branchId),
        Where('businessId').isExactly(businessId),
      ],
      orderBy: [OrderBy('sku', ascending: true)],
    );

    final skus = await repository.get<SKU>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Get highest sequence number
    int lastSequence = skus.isEmpty ? 0 : skus.last.sku ?? 0;
    final newSequence = lastSequence + 1;

    final newSku = SKU(
      sku: newSequence,
      branchId: branchId,
      businessId: businessId,
    );
    await repository.upsert(newSku);

    return newSku;
  }

  @override
  FutureOr<void> updateProduct(
      {String? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      String? imageUrl,
      required int branchId,
      required int businessId,
      String? categoryId,
      String? expiryDate}) async {
    final product = await getProduct(
        id: productId, branchId: branchId, businessId: businessId);
    if (product != null) {
      product.name = name ?? product.name;
      product.categoryId = categoryId ?? product.categoryId;
      product.isComposite = isComposite ?? product.isComposite;
      product.unit = unit ?? product.unit;
      product.expiryDate = expiryDate ?? product.expiryDate;
      product.imageUrl = imageUrl ?? product.imageUrl;
      product.color = color ?? product.color;
      await repository.upsert(product);
    }
  }

  @override
  Future<void> hydrateCodes({required int branchId}) async {
    await repository.get<ItemCode>(
      policy: brick.OfflineFirstGetPolicy.alwaysHydrate,
      query: brick.Query(
        where: [brick.Where('branchId').isExactly(branchId)],
      ),
    );
  }

  @override
  Future<void> hydrateSars({required int branchId}) async {
    await repository.get<Sar>(
      policy: brick.OfflineFirstGetPolicy.alwaysHydrate,
      query: brick.Query(
        where: [brick.Where('branchId').isExactly(branchId)],
      ),
    );
  }
}
