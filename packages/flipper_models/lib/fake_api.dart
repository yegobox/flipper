import 'isar_api.dart';
import 'isar_models.dart';
import 'package:http/http.dart' as http;

class FakeApi extends IsarAPI implements IsarApiInterface {
  @override
  Future<List<JTenant>> signup({required Map business}) async {
    // Simulating a successful API response
    final http.Response response = http.Response(
        '{"tenants": [{"id": 1, "name": "Tenant 1", "businessId": 1, "nfcEnabled": true, "email": "tenant1@example.com", "phoneNumber": "123456789"}]}',
        200);

    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        // Simulating a successful write transaction to a local database
        await isar.writeTxn(() async {
          return isar.business.putAll(jTenant.businesses);
        });
        await isar.writeTxn(() async {
          return await isar.branchs.putAll(jTenant.branches);
        });
        await isar.writeTxn(() async {
          return isar.permissions.putAll(jTenant.permissions);
        });
        await isar.writeTxn(() async {
          return isar.iTenants.put(iTenant);
        });
      }
      return jListTenantFromJson(response.body);
    } else {
      // Simulating an internal server error
      throw InternalServerError(term: "internal server error");
    }
  }
}
