import 'dart:convert';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_services/proxy.dart';

import 'isar_api.dart';
import 'isar_models.dart';
import 'package:http/http.dart' as http;

class FakeApi extends IsarAPI implements IsarApiInterface {
  @override
  Future<List<Tenant>> signup({required Map business}) async {
    // Simulating a successful API response
    final http.Response response = http.Response(
        '[{"messageId": 1, "userName": "Tenant 1", "businessId": 1642645, "nfcEnabled": true, "email": "tenant1@example.com", "phoneNumber": "${business['phoneNumber']}", "permissions":[{"messageId": 205, "userName":"admin"}], "branches":[{"messageId": 232,"active": true,"channels": null,"description": "desc","userName": "Test001","businessId": 1642645,"longitude": "0","latitude": "0","table": "branches","createdAt": "2/22/2021","updatedAt": null,"isDefault": true,"tenants": [],"default": true}], "businesses":[{"messageId": 1642645,"userName": "Test001","currency": null,"categoryId": null,"latitude": "293.98","longitude": "-344.49","userId": "1651165831880765","typeId": null,"timeZone": null,"channels": null,"table": null,"country": "Rwanda","businessUrl": null,"hexColor": null,"imageUrl": null,"type": "business","referredBy": "Richie","createdAt": "2/22/2021","updatedAt": null,"metadata": null,"role": null,"lastSeen": 0,"firstName": null,"lastName": null,"reported": null,"phoneNumber": "+250783054873","deviceToken": null,"chatUid": null,"backUpEnabled": false,"subscriptionPlan": null,"nextBillingDate": null,"previousBillingDate": null,"isLastSubscriptionPaymentSucceeded": false,"backupFileId": null,"email": null,"lastDbBackup": null,"fullName": "Richie","referralCode": null,"authId": null,"tinNumber": 12222,"dvcSrlNo": "warvsdcoriongatetest","bhfId": "00","adrs": null,"taxEnabled": false,"isDefault": true,"default": true,"lastSubscriptionPaymentSucceeded": false}]}]',
        200);

    if (response.statusCode == 200) {
      for (Tenant tenant in Tenant.fromJsonList(response.body)) {
        Tenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        // Simulating a successful write transaction to a local database
        await db.write((isar) async {
          return isar.business.putAll(jTenant.businesses);
        });
        await db.write((isar) async {
          isar.branchs.putAll(jTenant.branches);
        });
        await db.write((isar) async {
          return isar.permissions.putAll(jTenant.permissions);
        });
        await db.write((isar) async {
          return isar.iTenants.put(iTenant);
        });
      }
      return Tenant.fromJsonList(response.body);
    } else {
      // Simulating an internal server error
      throw InternalServerError(term: "internal server error");
    }
  }

  /// because when fake API is used we want to always start from signup
  /// when there is no business we will always get a business not found exception
  @override
  Future<Business> getOnlineBusiness({required int userId}) async {
    throw BusinessNotFoundException(term: "Business not found");
  }

  @override
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup}) async {
    final jsonResponse = {
      "messageId": 1651165831880765,
      "phoneNumber": "+250783054874",
      "token": "Bearer ",
      "tenants": [
        {
          "messageId": 49,
          "userName": "Richard",
          "phoneNumber": "+250783054874",
          "email": "nyiringabohubert@gmail.com",
          "permissions": [
            {"messageId": 49, "userName": "admin"}
          ],
          "branches": [
            {
              "messageId": 76,
              "active": true,
              "channels": null,
              "description": "desc",
              "userName": "Richard",
              "businessId": 1642645,
              "longitude": "0",
              "latitude": "0",
              "table": "branches",
              "createdAt": "2021-10-05T19:28:08.612022",
              "updatedAt": null,
              "isDefault": false,
              "default": false
            }
          ],
          "businesses": [
            {
              "messageId": 1642645,
              "userName": "FakeBusiness",
              "currency": "USD",
              "categoryId": null,
              "latitude": "1",
              "longitude": "1",
              "userId": "1651165831880765",
              "typeId": null,
              "timeZone": null,
              "channels": null,
              "table": null,
              "country": "United States",
              "businessUrl": null,
              "hexColor": null,
              "imageUrl": null,
              "type": "Business",
              "referredBy": "Organic",
              "createdAt": "2022-03-30T00:00:00.000Z",
              "updatedAt": null,
              "metadata": null,
              "role": null,
              "lastSeen": 0,
              "firstName": null,
              "lastName": null,
              "phoneNumber": "+1234567890",
              "deviceToken": null,
              "chatUid": null,
              "backUpEnabled": false,
              "subscriptionPlan": null,
              "nextBillingDate": null,
              "previousBillingDate": null,
              "isLastSubscriptionPaymentSucceeded": false,
              "backupFileId": null,
              "email": "fake@business.com",
              "lastDbBackup": null,
              "fullName": "Fake Business",
              "referralCode": null,
              "authId": null,
              "tinNumber": 123456,
              "dvcSrlNo": null,
              "bhfId": null,
              "adrs": null,
              "taxEnabled": false,
              "isDefault": true,
              "default": true,
              "businessTypeId": 1,
              "lastSubscriptionPaymentSucceeded": false
            }
          ],
          "businessId": 0,
          "nfcEnabled": false
        }
      ],
      "channels": ["1651165831880765"]
    };
    final response = http.Response(jsonEncode(jsonResponse), 200);
    if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Create an IUser object using the fromJson constructor
      IUser user = IUser.fromJson(jsonResponse);
      await ProxyService.box.writeString(
        key: 'bearerToken',
        value: user.token,
      );
      await ProxyService.box.writeString(
        key: 'defaultApp',
        value: user
            .tenants
            .first
            .businesses
            .first
            .businessTypeId
            .toString(),
      );
      await ProxyService.box.writeInt(
        key: 'userId',
        value: user.id,
      );
      await ProxyService.box.writeString(
        key: 'userPhone',
        value: "+250783054874",
      );
      if (user.tenants.isEmpty) {
        throw TenantNotFoundException(term: "No tenant added to the user");
      }
      db.write((isar) async {
        isar.business
            .putAll(user.tenants.first.businesses);
      });
      await db.write((isar) async {
        isar.branchs
            .putAll(user.tenants.first.branches);
      });

      return user;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception('403 Error');
    }
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    // Create a fake response JSON
    final responseJson = [
      {
        "messageId": 1,
        "userName": "FakeTenant",
        "phoneNumber": "+1234567890",
        "email": "fake@tenant.com",
        "permissions": [
          {"messageId": 1, "userName": "admin"}
        ],
        "branches": [
          {
            "messageId": 232,
            "active": true,
            "channels": null,
            "description": "Fake branch",
            "userName": "FakeBranch",
            "businessId": 1642636,
            "longitude": "0",
            "latitude": "0",
            "table": "branches",
            "createdAt": "2022-03-30T00:00:00.000Z",
            "updatedAt": null,
            "isDefault": true,
            "default": true
          }
        ],
        "businesses": [
          {
            "messageId": 1642636,
            "userName": "FakeBusiness",
            "currency": "USD",
            "categoryId": null,
            "latitude": "1",
            "longitude": "1",
            "userId": "1651165831880765",
            "typeId": null,
            "timeZone": null,
            "channels": null,
            "table": null,
            "country": "United States",
            "businessUrl": null,
            "hexColor": null,
            "imageUrl": null,
            "type": "Business",
            "referredBy": "Organic",
            "createdAt": "2022-03-30T00:00:00.000Z",
            "updatedAt": null,
            "metadata": null,
            "role": null,
            "lastSeen": 0,
            "firstName": null,
            "lastName": null,
            "phoneNumber": "+1234567890",
            "deviceToken": null,
            "chatUid": null,
            "backUpEnabled": false,
            "subscriptionPlan": null,
            "nextBillingDate": null,
            "previousBillingDate": null,
            "isLastSubscriptionPaymentSucceeded": false,
            "backupFileId": null,
            "email": "fake@business.com",
            "lastDbBackup": null,
            "fullName": "Fake Business",
            "referralCode": null,
            "authId": null,
            "tinNumber": 123456,
            "dvcSrlNo": null,
            "bhfId": null,
            "adrs": null,
            "taxEnabled": false,
            "isDefault": true,
            "default": true,
            "lastSubscriptionPaymentSucceeded": false
          }
        ],
        "businessId": 1,
        "nfcEnabled": false
      }
    ];
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      for (Tenant tenant in Tenant.fromJsonList(response.body)) {
        Tenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        db.write((isar) async {
          isar.business.putAll(jTenant.businesses);
          isar.branchs.putAll(jTenant.branches);
          isar.permissions.putAll(jTenant.permissions);
        });
        db.write((isar) async {
          isar.iTenants.put(iTenant);
        });
      }
      return await db.iTenants.where().businessIdEqualTo(businessId).findAll();
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<void> loadCounterFromOnline({required int businessId}) async {
    final responseJson = [
      {
        "messageId": 11,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "NS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 12,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "TS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 13,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "NR",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 14,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "CS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 15,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "PS",
        "totRcptNo": 0,
        "curRcptNo": 0
      }
    ];
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      List<Counter> counters = Counter.fromJsonList(jsonResponse);
      for (Counter counter in counters) {
        await db.write((isar) async {
          isar.counters.put(Counter(
            id: counter.id,
            branchId: counter.branchId,
            businessId: counter.branchId,
            receiptType: counter.receiptType,
            totRcptNo: counter.totRcptNo,
            curRcptNo: counter.curRcptNo,
          ));
        });
      }
    } else {
      throw InternalServerError(term: "Error loading the counters");
    }
  }

  @override
  Future<T?> update<T>({required T data}) async {
    // int branchId = ProxyService.box.getBranchId()!;
    if (data is Product) {
      Product product = data;

      await db.write((isar) async {
        isar.products.put(product);
      });
    }
    if (data is Variant) {
      Variant variant = data;
      await db.write((isar) async {
        isar.variants.put(variant);
      });
    }
    if (data is Stock) {
      Stock stock = data;
      await db.write((isar) async {
        isar.stocks.put(stock);
      });
    }
    if (data is Transaction) {
      final transaction = data;
      await db.write((isar) async {
        isar.transactions.put(transaction);
      });
    }
    if (data is Category) {
      final transaction = data;
      await db.write((isar) async {
        isar.categorys.put(transaction);
      });
    }
    if (data is IUnit) {
      final unit = data;
      await db.write((isar) async {
        isar.iUnits.put(unit);
      });
    }
    if (data is PColor) {
      final color = data;
      await db.write((isar) async {
        isar.pColors.put(color);
      });
    }
    if (data is TransactionItem) {
      await db.write((isar) async {
        isar.transactionItems.put(data);
      });
    }
    if (data is EBM) {
      final ebm = data;
      await db.write((isar) async {
        ProxyService.box
            .writeString(key: "serverUrl", value: ebm.taxServerUrl ?? 'null');
        Business? business =
            await isar.business.where().userIdEqualTo(ebm.userId).findFirst();
        business
          ?..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        isar.business.put(business!);
      });
    }
    if (data is Token) {
      final token = data;
      await db.write((isar) async {
        Token? ttoken = await isar.tokens
            .where()
            .businessIdEqualTo(token.businessId)
            .findFirst();
        if (ttoken == null) {
          ttoken = Token(
              id: randomString(),
              businessId: token.businessId,
              token: token.token,
              type: token.type,
              validFrom: token.validFrom,
              validUntil: token.validUntil);

          isar.tokens.put(ttoken);
        } else {
          ttoken
            ..token = token.token
            ..businessId = token.businessId
            ..type = token.type;
          isar.tokens.put(ttoken);
        }
      });
    }
    if (data is Business) {
      final business = data;
      await db.write((isar) async {
        isar.business.put(business);
      });
    }
    if (data is Branch) {
      db.write((isar) async {
        isar.branchs.put(data);
      });
    }
    if (data is Counter) {
      await db.write((isar) async {
        return isar.counters.put(data);
      });
    }
    if (data is Branch) {
      db.write((isar) async {
        isar.branchs.put(data);
      });
    }
    if (data is Drawers) {
      final drawer = data;
      await db.write((isar) async {
        isar.drawers.put(drawer);
      });
    }
    if (data is ITenant) {
      return null;
    }
    return null;
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": 1, "typeName": "Flipper Supplier"},
      {"id": 2, "typeName": "Flipper Connecta"},
      // {"id": 3, "typeName": "Retailer"},
      // {"id": 4, "typeName": "Agent"}
    ];
    Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Stream<List<Conversation>> conversations({String? conversationId}) async* {
    // https://randomuser.me/api/portraits/men/3.jpg
    final responseJson = [
      {
        "messageId": "1",
        "userName": "Alice",
        "body": "Hey, whats up?",
        "avatar":
            "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/tgWpp.png",
        "channelType": "whatsapp",
        "toNumber": "250783054874",
        "fromNumber": "250788360058",
        "createdAt": "11/3/2024",
        "respondedBy": "none",
        "conversationId": "250783054874"
      },
      {
        "messageId": "2",
        "userName": "Bob",
        "body": "Hello, nice to meet you.",
        "avatar":
            "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/tgWpp.png",
        "channelType": "instagram",
        "toNumber": "250788360058",
        "fromNumber": "250783054874",
        "createdAt": "11/3/2024",
        "respondedBy": "none",
        "conversationId": "2"
      },
      {
        "messageId": "3",
        "userName": "Alice",
        "body": "Hi, how are you?",
        "avatar":
            "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/tgWpp.png",
        "channelType": "whatsapp",
        "toNumber": "250783054874",
        "fromNumber": "250788360058",
        "createdAt": "11/3/2024",
        "respondedBy": "none",
        "conversationId": "2"
      },
    ];
    if (conversationId != null) {
      // build avatar given the conversationId
      String? avatar;
      String? source;
      String? message;
      if (conversationId == "250783054874") {
        avatar = "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/tgWpp.png";
        source = "whatsapp";
        message = "Hey, whats up?";
      }
      if (conversationId == "2") {
        avatar = "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/tgWpp.png";
        source = "instagram";
        message = "Hello, nice to meet you.";
      }
      final json = [
        {
          "messageId": conversationId,
          "userName": "Bob",
          "body": message,
          "avatar": avatar,
          "channelType": source,
          "toNumber": "250788360058",
          "fromNumber": "250783054874",
          "createdAt": "11/3/2024",
          "respondedBy": "none",
          "conversationId": conversationId
        },
        {
          "messageId": conversationId,
          "userName": "Bob",
          "body": message,
          "avatar": avatar,
          "channelType": source,
          "toNumber": "250783054874",
          "fromNumber": "250788360058",
          "createdAt": "11/3/2024",
          "respondedBy": "none",
          "conversationId": "2"
        },
      ];
      final response = http.Response(jsonEncode(json), 200);
      if (response.statusCode == 200) {
        yield Conversation.fromJsonList(jsonEncode(json));
      } else {
        throw Exception();
      }
    } else {
      final response = http.Response(jsonEncode(responseJson), 200);
      if (response.statusCode == 200) {
        // remove duplicates where the same user has sent multiple messages use userName as key

        // yield Conversation.fromJsonList(jsonEncode(responseJson));
        final uniqueUserNames = <String>{};

        // Create a list to store the unique conversations
        final uniqueConversations = <Conversation>[];

        // Loop through each message in the responseJson
        for (final message
            in Conversation.fromJsonList(jsonEncode(responseJson))) {
          // Check if the username of the message is already in the set
          if (!uniqueUserNames.contains(message.userName)) {
            // If not, add the username to the set and add the message to the uniqueConversations list
            uniqueUserNames.add(message.userName);
            uniqueConversations.add(message);
          }
        }

        // Yield the uniqueConversations list as a stream
        yield uniqueConversations;
      } else {
        throw Exception();
      }
    }
  }
}
