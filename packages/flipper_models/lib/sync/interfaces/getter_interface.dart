import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';

abstract class GetterInterface {
  FutureOr<Branch?> branch({required int serverId});
  Stream<List<Variant>> geVariantStreamByProductId({required String productId});
  FutureOr<Assets?> getAsset({String? assetName, String? productId});
  FutureOr<Business?> getBusiness({int? businessId});
  FutureOr<Business?> getBusinessById({required int businessId});
  Future<Business?> getBusinessFromOnlineGivenId({
    required int id,
    required HttpClientInterface flipperHttpClient,
  });
  FutureOr<Configurations?> getByTaxType({required String taxtype});
  Future<PColor?> getColor({required String id});
  Future<Counter?> getCounter({
    required int branchId,
    required String receiptType,
  });
  Future<List<Counter>> getCounters({
    required int branchId,
    bool fetchRemote = false,
  });
  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
  });
  FutureOr<List<Customer>> customers({
    required int branchId,
    String? key,
    String? id,
  });
}
