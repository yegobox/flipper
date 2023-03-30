import 'package:flipper_services/proxy.dart';

import 'isar_api.dart';
import 'isar_models.dart';
import 'package:http/http.dart' as http;

class FakeApi extends IsarAPI implements IsarApiInterface {
  @override
  Future<List<JTenant>> signup({required Map business}) async {
    // Simulating a successful API response
    final http.Response response = http.Response(
        '[{"id": 1, "name": "Tenant 1", "businessId": 1, "nfcEnabled": true, "email": "tenant1@example.com", "phoneNumber": "${business['phoneNumber']}", "permissions":[{"id": 205, "name":"admin"}], "branches":[{"id": 232,"active": true,"channels": null,"description": "desc","name": "Test001","businessId": 1642645,"longitude": "0","latitude": "0","table": "branches","createdAt": "2/22/2021","updatedAt": null,"isDefault": true,"tenants": [],"default": true}], "businesses":[{"id": 1642645,"name": "Test001","currency": null,"categoryId": null,"latitude": "293.98","longitude": "-344.49","userId": "1651165831880765","typeId": null,"timeZone": null,"channels": null,"table": null,"country": "Rwanda","businessUrl": null,"hexColor": null,"imageUrl": null,"type": "business","referredBy": "Richie","createdAt": "2/22/2021","updatedAt": null,"metadata": null,"role": null,"lastSeen": 0,"firstName": null,"lastName": null,"reported": null,"phoneNumber": "+250783054873","deviceToken": null,"chatUid": null,"backUpEnabled": false,"subscriptionPlan": null,"nextBillingDate": null,"previousBillingDate": null,"isLastSubscriptionPaymentSucceeded": false,"backupFileId": null,"email": null,"lastDbBackup": null,"fullName": "Richie","referralCode": null,"authId": null,"tinNumber": 12222,"dvcSrlNo": "warvsdcoriongatetest","bhfId": "00","adrs": null,"taxEnabled": false,"isDefault": true,"default": true,"lastSubscriptionPaymentSucceeded": false}]}]',
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

  @override
  Future<Business> getOnlineBusiness({required String userId}) async {
    // Fake response with the provided data
    final response = http.Response(
      '{ "id": 1642645, "name": "Test001", "currency": null, "categoryId": null, "latitude": "293.98", "longitude": "-344.49", "userId": "1651165831880765", "typeId": null, "timeZone": null, "channels": null, "table": null, "country": "Rwanda", "businessUrl": null, "hexColor": null, "imageUrl": null, "type": "business", "referredBy": "Richie", "createdAt": "2/22/2021", "updatedAt": null, "metadata": null, "role": null, "lastSeen": 0, "firstName": null, "lastName": null, "reported": "true", "phoneNumber": "+250783054873", "deviceToken": null, "chatUid": null, "backUpEnabled": false, "subscriptionPlan": null, "nextBillingDate": null, "previousBillingDate": null, "isLastSubscriptionPaymentSucceeded": false, "backupFileId": null, "email": null, "lastDbBackup": null, "fullName": "Richie", "referralCode": null, "authId": null, "tinNumber": 12222, "dvcSrlNo": "warvsdcoriongatetest", "bhfId": "00", "adrs": null, "taxEnabled": false, "isDefault": true, "default": true, "lastSubscriptionPaymentSucceeded": false }',
      200,
    );

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw NotFoundException(term: "Business not found");
    }

    // Parse the response body and create a Business object
    final business = fromJson(response.body);

    await isar.writeTxn(() async {
      // Put the business object in the database
      return isar.business.put(business);
    });

    // Get the business object from the database
    final savedBusiness = await isar.writeTxn(() {
      return isar.business.filter().userIdEqualTo(userId).findFirst();
    });

    ProxyService.box.write(key: 'businessId', value: savedBusiness!.id);

    return savedBusiness;
  }

  @override
  Future<SyncF> login({required String userPhone}) async {
    final response = http.Response(
        '{"id": 1651165831880765,"phoneNumber": "+250783054874","token": "Bearer ","tenants": [{"id": 49,  "name": "Richard", "phoneNumber": "+250783054874", "email": "nyiringabohubert@gmail.com", "permissions": [{ "id": 49, "name": "admin"}],"branches": [{"id": 76, "active": true, "channels": null,"description": "desc","name": "Richard","businessId": 68, "longitude": "0","latitude": "0","table": "branches","createdAt": "2021-10-05T19:28:08.612022","updatedAt": null,"isDefault": false,"tenants": [],"default": false}],"businesses": [],"businessId": 0,"nfcEnabled": false}],"channels": ["1651165831880765"],"points": 0,"editId": false,"newId": 0}',
        200);
    if (response.statusCode == 200) {
      await ProxyService.box.write(
        key: 'bearerToken',
        value: syncFFromJson(response.body).token,
      );
      await ProxyService.box.write(
        key: 'userId',
        value: syncFFromJson(response.body).id.toString(),
      );
      await ProxyService.box.write(
        key: 'userPhone',
        value: "+250783054874",
      );
      if (syncFFromJson(response.body).tenants.isEmpty) {
        throw NotFoundException(term: "Not found");
      }
      await isar.writeTxn(() async {
        return isar.business
            .putAll(syncFFromJson(response.body).tenants.first.businesses);
      });
      await isar.writeTxn(() async {
        return isar.branchs
            .putAll(syncFFromJson(response.body).tenants.first.branches);
      });

      return syncFFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception('403 Error');
    }
  }
}
