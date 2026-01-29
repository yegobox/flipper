import 'dart:async';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

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
    throw UnimplementedError('getSku needs to be implemented for Capella');
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
    throw UnimplementedError(
      'createProduct needs to be implemented for Capella',
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
  }) {
    throw UnimplementedError(
      'updateProduct needs to be implemented for Capella',
    );
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
