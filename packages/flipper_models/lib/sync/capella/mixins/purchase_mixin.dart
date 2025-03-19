import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaPurchaseMixin implements PurchaseInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastRequestdate,
  }) async {
    throw UnimplementedError(
        'selectImportItems needs to be implemented for Capella');
  }

  @override
  Future<List<Variant>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
    required String lastRequestdate,
  }) async {
    throw UnimplementedError(
        'selectPurchases needs to be implemented for Capella');
  }

  @override
  Future<void> saveVariant(
    Variant item,
    Business business,
    int branchId,
  ) async {
    throw UnimplementedError('saveVariant needs to be implemented for Capella');
  }

  @override
  Future<List<Purchase>> purchases() {
    throw UnimplementedError('purchases needs to be implemented for Capella');
  }
}
