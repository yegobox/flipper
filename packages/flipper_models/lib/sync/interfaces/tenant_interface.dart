import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/realm_model_export.dart';

abstract class TenantInterface {
  Future<Tenant?> saveTenant({
    required Business business,
    required Branch branch,
    String? phoneNumber,
    String? name,
    String? id,
    String? email,
    int? businessId,
    bool? sessionActive,
    int? branchId,
    String? imageUrl,
    int? pin,
    bool? isDefault,
    required HttpClientInterface flipperHttpClient,
    required String userType,
  });

  Stream<Tenant?> getDefaultTenant({required int businessId});

  Future<Branch> activeBranch();

  Future<Business?> activeBusiness({int? userId});
}
