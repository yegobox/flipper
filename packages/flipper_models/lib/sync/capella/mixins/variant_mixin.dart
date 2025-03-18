import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaVariantMixin implements VariantInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    String? variantId,
    int? page,
    String? purchaseId,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    int? itemsPerPage,
    String? name,
    String? bcd,
    String? imptItemsttsCd,
    bool fetchRemote = false,
  }) async {
    throw UnimplementedError('variants needs to be implemented for Capella');
  }

  @override
  Future<Variant?> getVariant({required String id}) async {
    throw UnimplementedError('getVariant needs to be implemented for Capella');
  }

  @override
  Future<int> addVariant({
    required List<Variant> variations,
    required int branchId,
  }) async {
    throw UnimplementedError('addVariant needs to be implemented for Capella');
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    throw UnimplementedError('units needs to be implemented for Capella');
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    throw UnimplementedError('addUnits needs to be implemented for Capella');
  }
}
