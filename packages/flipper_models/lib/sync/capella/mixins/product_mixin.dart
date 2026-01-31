import 'dart:async';
import 'dart:math';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:uuid/uuid.dart';

mixin CapellaProductMixin implements ProductInterface {
  DittoService get dittoService => DittoService.instance;
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Product>> products({required String branchId}) async {
    throw UnimplementedError('products needs to be implemented for Capella');
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
    throw UnimplementedError(
      'productStreams needs to be implemented for Capella',
    );
  }

  @override
  Future<double> totalStock({String? productId, String? variantId}) async {
    throw UnimplementedError('totalStock needs to be implemented for Capella');
  }

  @override
  Stream<double> wholeStockValue({required String branchId}) {
    throw UnimplementedError(
      'wholeStockValue needs to be implemented for Capella',
    );
  }

  @override
  Future<String> itemCode({
    required String countryCode,
    required String productType,
    required packagingUnit,
    required String branchId,
    required String quantityUnit,
  }) async {
    throw UnimplementedError('itemCode needs to be implemented for Capella');
  }

  @override
  Future<Product?> getProduct({
    String? id,
    String? barCode,
    required String branchId,
    String? name,
    required String businessId,
  }) async {
    final logService = LogService();
    try {
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting getProduct fetch',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'getProduct',
            'branchId': branchId,
            'businessId': businessId,
            'id': id ?? 'null',
            'barCode': barCode ?? 'null',
            'name': name ?? 'null',
          },
        );
      }

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:19');
        return null;
      }

      /// a work around to first register to whole data instead of subset
      /// this is because after test on new device, it can't pull data using complex query
      /// there is open issue on ditto https://support.ditto.live/hc/en-us/requests/2648?page=1
      ///
      ditto.sync.registerSubscription(
        "SELECT * FROM products WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM products WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      // Workaround for initial sync
      ditto.sync.registerSubscription(
        "SELECT * FROM products WHERE branchId = :branchId AND businessId = :businessId",
        arguments: {'branchId': branchId, 'businessId': businessId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM products WHERE branchId = :branchId AND businessId = :businessId",
        arguments: {'branchId': branchId, 'businessId': businessId},
      );

      final List<String> whereClauses = [
        'branchId = :branchId',
        'businessId = :businessId',
      ];
      final Map<String, dynamic> arguments = {
        'branchId': branchId,
        'businessId': businessId,
      };

      if (id != null) {
        whereClauses.add('id = :id');
        arguments['id'] = id;
      }
      if (barCode != null) {
        whereClauses.add('barCode = :barCode');
        arguments['barCode'] = barCode;
      }
      if (name != null) {
        whereClauses.add('name = :name');
        arguments['name'] = name;
      }

      final query =
          "SELECT * FROM products WHERE ${whereClauses.join(' AND ')}";

      await ditto.sync.registerSubscription(query, arguments: arguments);

      final completer = Completer<Product?>();
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            if (result.items.isNotEmpty) {
              completer.complete(
                Product.fromJson(
                  Map<String, dynamic>.from(result.items.first.value),
                ),
              );
            } else {
              // We don't complete with null immediately to allow sync to catch up
              // unless we want to timeout.
            }
          }
        },
      );

      try {
        return await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
            return null;
          },
        );
      } finally {
        observer.cancel();
      }
    } catch (e, st) {
      talker.error('Error in getProduct: $e\n$st');
      return null;
    }
  }

  @override
  FutureOr<SKU> getSku({
    required String branchId,
    required String businessId,
  }) async {
    final query = brick.Query(
      where: [
        brick.Where('branchId').isExactly(branchId),
        brick.Where('businessId').isExactly(businessId),
      ],
      orderBy: [brick.OrderBy('sku', ascending: true)],
    );

    final skus = await repository.get<SKU>(
      query: query,
      policy: brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    int lastSequence = skus.isEmpty ? 0 : skus.last.sku ?? 0;
    final newSequence = lastSequence + 1;

    final newSku = SKU(
      sku: newSequence,
      branchId: branchId,
      businessId: businessId,
    );
    await repository.upsert(newSku);

    // Sync SKU to Ditto
    final ditto = dittoService.dittoInstance;
    if (ditto != null) {
      await ditto.store.execute(
        "INSERT INTO skus DOCUMENTS (:doc) ON ID CONFLICT DO REPLACE",
        arguments: {'doc': newSku.toJson()},
      );
    }

    return newSku;
  }

  @override
  Future<Product?> createProduct({
    required Product product,
    required String businessId,
    required bool skipRRaCall,
    required String branchId,
    required int tinNumber,
    required String bhFId,
    Map<String, String>? taxTypes,
    Map<String, String>? itemClasses,
    Map<String, String>? itemTypes,
    double? splyAmt,
    String? taxTyCd,
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
    String? itemCd,
  }) async {
    try {
      final String productName = product.name;
      if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
        final Product? existingProduct = await getProduct(
          name: productName,
          businessId: businessId,
          branchId: branchId,
        );
        if (existingProduct != null) {
          return existingProduct;
        }
      }

      SKU sku = await getSku(branchId: branchId, businessId: businessId);

      sku.consumed = true;
      await repository.upsert(sku);

      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO skus DOCUMENTS (:doc) ON ID CONFLICT DO REPLACE",
          arguments: {'doc': sku.toJson()},
        );
      }

      final createdProduct = await repository.upsert<Product>(product);
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO products DOCUMENTS (:doc) ON ID CONFLICT DO REPLACE",
          arguments: {'doc': createdProduct.toJson()},
        );
      }

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
            'Variant already exists with ID: ${existingVariants.first.id}',
          );
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
          value: (qty * (retailPrice > 0 ? retailPrice : supplyPrice))
              .toDouble(),
          branchId: branchId,
          currentStock: qty,
        );

        // Save stock first and get the created instance
        final createdStock = await repository.upsert<Stock>(stock);
        if (ditto != null) {
          await ditto.store.execute(
            "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO REPLACE",
            arguments: {'doc': createdStock.toJson()},
          );
        }
        talker.info('Created stock: ${createdStock.id} for variant');

        // Set stock reference on variant
        newVariant.stock = createdStock;
        newVariant.stockId = createdStock.id;
        newVariant.ebmSynced = false;

        // Use ProxyService.strategy.addVariant to save the variant
        // This ensures EBM sync and SAR increment logic is applied
        await ProxyService.strategy.addVariant(
          variations: [newVariant],
          branchId: branchId,
          skipRRaCall: skipRRaCall,
        );

        final savedVariant = newVariant;
        if (savedVariant.stockId == null) {
          talker.error('Variant ${savedVariant.id} has no stockId after save!');
        }

        talker.info(
          'Variant ${savedVariant.id} created with stock ${savedVariant.stockId}',
        );

        // If associated with a purchase ... (omitting purchase logic for brevity if not strictly needed now, or I can add it)
        // Adding it to be safe.
        if (purchase != null) {
          if (purchase.variants == null) {
            purchase.variants = [];
          }
          final variantExists =
              purchase.variants?.any((v) => v.id == savedVariant.id) ?? false;

          if (!variantExists) {
            purchase.variants = [...purchase.variants ?? [], savedVariant];
            savedVariant.spplrNm = purchase.spplrNm;
            savedVariant.purchaseId = purchase.id;

            try {
              await repository.upsert<Variant>(savedVariant);
              // Ditto sync for variant done in addVariant? Yes.
              await repository.upsert<Purchase>(purchase);
              // Ditto sync for purchase?
              if (ditto != null) {
                // Assuming Purchase has toJson
                // await ditto.store.execute(...)
                // Not strictly in scope for "Fixing upsert", but good hygiene.
              }

              talker.info(
                'Added variant ${savedVariant.id} to purchase ${purchase.id}',
              );
            } catch (e) {
              talker.error('Error saving variant/purchase association: $e');
              rethrow;
            }
          } else {
            talker.info(
              'Variant ${savedVariant.id} already exists in purchase ${purchase.id}',
            );
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

  Future<Variant> _createRegularVariant(
    String branchId,
    int? tinNumber, {
    required double qty,
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
    double? splyAmt,
  }) async {
    final String variantId = const Uuid().v4();
    final number = randomNumber().toString().substring(0, 5);
    Category? category = (await repository.get<Category>(
      query: brick.Query(where: [brick.Where('id').isExactly(categoryId)]),
    )).firstOrNull;

    // Determine tax type code - prioritize explicit taxTyCd, then taxTypes map, then default to "B"
    String finalTaxTyCd = taxTyCd ?? taxTypes?[product?.barCode] ?? "B";

    // Get tax percentage based on the tax type code
    double finalTaxPercentage = taxType?.taxPercentage ?? 18.0;
    try {
      Configurations? taxConfig = await ProxyService.strategy.getByTaxType(
        taxtype: finalTaxTyCd,
      );
      if (taxConfig != null) {
        finalTaxPercentage = taxConfig.taxPercentage!;
      }
    } catch (e) {
      talker.warning(
        'Failed to get tax configuration for $finalTaxTyCd, using default: $e',
      );
    }

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
              packagingUnit: pkgUnitCd ?? "CT",
              quantityUnit: qtyUnitCd ?? "U",
              branchId: branchId,
            )
          : itemCd ?? "",
      modrNm: name,
      modrId: number,
      pkgUnitCd: pkgUnitCd ?? "CT",
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
      taxPercentage: finalTaxPercentage,
      taxName: finalTaxTyCd,
      tin: tinNumber,
      bcd:
          bcd ??
          (product?.name ?? name).substring(
            0,
            min((product?.name ?? name).length, 20),
          ),

      /// country of origin for this item we default until we support something different
      /// and this will happen when we do import.
      orgnNatCd: orgnNatCd ?? "RW",

      /// registration name
      regrNm: product?.name ?? name,

      /// taxation type code
      taxTyCd: finalTaxTyCd,

      // default unit price
      dftPrc: retailPrice,
      prc: retailPrice,

      /// Packaging Unit and Quantity Unit
      qtyUnitCd: qtyUnitCd ?? "U", // see 4.6 in doc
      ebmSynced: ebmSynced,
      spplrItemCd: spplrItemCd ?? "",
      spplrItemClsCd: itemClasses?[product?.barCode] ?? spplrItemClsCd,
      spplrItemNm: product?.name ?? name,
      isrccNm: "",
      isrcRt: 0,
    );
  }

  @override
  FutureOr<void> updateProduct({
    String? productId,
    String? name,
    bool? isComposite,
    String? unit,
    String? color,
    required String branchId,
    required String businessId,
    String? imageUrl,
    String? expiryDate,
    String? categoryId,
  }) async {
    final logService = LogService();
    try {
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting updateProduct',
          type: 'business_update',
          tags: {
            'method': 'updateProduct',
            'productId': productId ?? 'null',
            'branchId': branchId,
          },
        );
      }

      final Product? product = await getProduct(
        id: productId,
        branchId: branchId,
        businessId: businessId,
      );

      if (product != null) {
        final ditto = dittoService.dittoInstance;

        // Update local object
        product.name = name ?? product.name;
        product.categoryId = categoryId ?? product.categoryId;
        product.isComposite = isComposite ?? product.isComposite;
        product.unit = unit ?? product.unit;
        product.expiryDate = expiryDate ?? product.expiryDate;
        product.imageUrl = imageUrl ?? product.imageUrl;
        product.color = color ?? product.color;
        product.lastTouched = DateTime.now().toUtc(); // Update last touched

        // Upsert to local repository
        await repository.upsert(product);

        // Update in Ditto
        if (ditto != null) {
          await ditto.store.execute(
            "INSERT INTO products DOCUMENTS (:doc) ON ID CONFLICT DO REPLACE",
            arguments: {'doc': product.toJson()},
          );
          if (ProxyService.box.getUserLoggingEnabled() ?? false) {
            await logService.logException(
              'Updated product in Ditto',
              type: 'business_update',
              tags: {'method': 'updateProduct', 'productId': product.id},
            );
          }
        }
      }
    } catch (e, st) {
      talker.error('Error updating product: $e\n$st');
      await logService.logException(
        'Error updating product',
        stackTrace: st,
        type: 'business_update',
        tags: {'method': 'updateProduct', 'error': e.toString()},
      );
      rethrow;
    }
  }

  @override
  Future<void> hydrateDate({required String branchId}) async {
    throw UnimplementedError('hydrateDate needs to be implemented for Capella');
  }

  @override
  Future<void> hydrateCodes({required String branchId}) {
    // TODO: implement hydrateCodes
    throw UnimplementedError();
  }

  @override
  Future<void> hydrateSars({required String branchId}) {
    // TODO: implement hydrateSars
    throw UnimplementedError();
  }
}
