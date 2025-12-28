import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';

abstract class GetterInterface {
  FutureOr<Branch?> branch({required int serverId});
  Stream<List<Variant>> geVariantStreamByProductId({required String productId});
  FutureOr<Assets?> getAsset({String? assetName, String? productId});
  FutureOr<Business?> getBusiness({String? businessId});
  FutureOr<Business?> getBusinessById({required String businessId});
  Future<Business?> getBusinessFromOnlineGivenId({
    required int id,
    required HttpClientInterface flipperHttpClient,
  });
  FutureOr<Configurations?> getByTaxType({required String taxtype});
  Future<PColor?> getColor({required String id});
  Future<Counter?> getCounter({
    required String branchId,
    required String receiptType,
  });
  Future<List<Counter>> getCounters({
    required String branchId,
    bool fetchRemote = false,
  });
  Future<Variant?> getCustomVariant({
    required String businessId,
    required String branchId,
    required int tinNumber,
    required String bhFId,
  });
  FutureOr<List<Customer>> customers({
    String? branchId,
    String? key,
    String? id,
  });
}
