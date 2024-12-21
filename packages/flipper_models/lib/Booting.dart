import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firestore_models/firestore_models.dart' as odm;
import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
import 'package:cbl/cbl.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

mixin Booting {
  Future<void> updateLocalRealm(IUser user,
      {Realm? localRealm, bool usenewVersion = false}) async {
    for (ITenant tenant in user.tenants) {
      await _addOrUpdateTenant(
        tenant,
        user.id.toString(),
        localRealm: localRealm,
        usenewVersion: usenewVersion,
      );
    }
  }

  Future<void> _addOrUpdateTenant(ITenant tenant, String userId,
      {Realm? localRealm, required bool usenewVersion}) async {
    final Tenant iTenant = Tenant(
      ObjectId(),
      isDefault: tenant.isDefault,
      id: tenant.id,
      name: tenant.name,
      businessId: tenant.businessId,
      nfcEnabled: tenant.nfcEnabled,
      email: tenant.email,
      userId: int.tryParse(userId),
      phoneNumber: tenant.phoneNumber,
      pin: tenant.pin,
    );

    await addOrUpdateBusinesses(
      tenant.businesses,
      userId,
      localRealm: localRealm,
      usenewVersion: usenewVersion,
    );
    await addOrUpdateBranches(
      tenant.branches,
      localRealm: localRealm,
      usenewVersion: usenewVersion,
    );
    await addOrUpdatePermissions(
      tenant.permissions,
      localRealm: localRealm,
      usenewVersion: usenewVersion,
    );
    await addOrUpdateTenantInRealm(iTenant, userId, localRealm: localRealm);
  }

  Future<void> addOrUpdateTenantInRealm(Tenant iTenant, String userId,
      {Realm? localRealm}) async {
    Tenant? exist = ProxyService.local.realm!
        .query<Tenant>(r'id == $0', [iTenant.id]).firstOrNull;
    if (exist == null) {
      await ProxyService.local.updateTenant(
          tenantId: iTenant.id!, sessionActive: (userId == iTenant.userId));
    }
  }

  Future<void> addOrUpdatePermissions(List<IPermission> permissions,
      {Realm? localRealm, required bool usenewVersion}) async {
    final List<LPermission> permissionToAdd = [];
    final List<String> features = ['Sales', 'Inventory', 'Reports', 'Settings'];

    for (IPermission permission in permissions) {
      LPermission? exist = ProxyService.local.realm!
          .query<LPermission>(r'userId == $0', [permission.userId]).firstOrNull;

      if (exist == null) {
        final perm = LPermission(
          ObjectId(),
          id: randomNumber(),
          name: permission.name,
          userId: permission.userId,
        );
        permissionToAdd.add(perm);
        if (!usenewVersion) {
          final doc = await ProxyService.capela.permissionCollection
              ?.document(permission.userId.toString());
          if (doc == null) {
            final odm.LPermission iPermission = odm.LPermission(
              id: randomNumber(),
              name: permission.name,
              userId: permission.userId,
            );
            var doc = MutableDocument.withId(
                iPermission.id.toString(), iPermission.toJson());
            ProxyService.capela.permissionCollection?.saveDocument(doc);
          }
        }

        // Check if the permission is "admin" and handle access creation
        if (permission.name.toLowerCase() == 'admin') {
          for (String featureName in features) {
            if (!usenewVersion) {
              final Access? existingAccess = ProxyService.local.realm!
                  .query<Access>(r'userId == $0 AND featureName == $1',
                      [permission.userId, featureName]).firstOrNull;

              if (existingAccess == null) {
                ProxyService.local.addAccess(
                  branchId: ProxyService.box.getBranchId()!,
                  businessId: ProxyService.box.getBusinessId()!,
                  userId: permission.userId,
                  featureName: featureName,
                  accessLevel: 'Admin'.toLowerCase(),
                  status: 'active',
                  userType: "Admin",
                );
              }
            } else {
              /// in new version use use capella
              final doc = await ProxyService.capela.accessCollection
                  ?.document(permission.userId.toString());

              if (doc == null) {
                final odm.Accesses access = odm.Accesses(
                  accessLevel: 'Admin',
                  id: randomNumber(),
                  userId: permission.userId,
                  featureName: featureName,
                  createdAt: DateTime.now(),
                  expiresAt: DateTime.now().add(Duration(days: 365)),
                  status: 'active',
                  branchId: ProxyService.box.getBranchId(),
                  businessId: ProxyService.box.getBusinessId(),
                  userType: "Admin",
                );
                var doc = MutableDocument.withId(
                    access.id.toString(), access.toJson());
                ProxyService.capela.accessCollection?.saveDocument(doc);
              }
            }
          }
        }
      }
    }
  }

  Future<void> addOrUpdateBranches(List<IBranch> branches,
      {Realm? localRealm, required bool usenewVersion}) async {
    if (!usenewVersion) {
      localRealm!.write(() {
        for (IBranch branch in branches) {
          if (localRealm
                  .query<Branch>(r'serverId == $0', [branch.id]).firstOrNull ==
              null) {
            localRealm.add(Branch(
              ObjectId(),
              id: branch.id,
              serverId: branch.id,
              description: branch.description,
              name: branch.name,
              businessId: branch.businessId,
              longitude: branch.longitude,
              latitude: branch.latitude,
              isDefault: false,
              active: false,
              lastTouched: branch.lastTouched,
              deletedAt: branch.deletedAt,
            ));
            talker.warning("When adding branch");
          }
        }
      });
    } else {
      for (IBranch branch in branches) {
        final doc = await ProxyService.capela.branchCollection
            ?.document(branch.id.toString());
        if (doc == null) {
          final odm.Branch iBranch = odm.Branch(
            id: branch.id,
            serverId: branch.id,
            description: branch.description,
            name: branch.name,
            businessId: branch.businessId,
            longitude: branch.longitude,
            latitude: branch.latitude,
            isDefault: false,
            active: false,
            lastTouched: branch.lastTouched,
          );
          var doc =
              MutableDocument.withId(iBranch.id.toString(), iBranch.toJson());
          ProxyService.capela.branchCollection?.saveDocument(doc);
        }
      }
    }
  }

  Future<void> addOrUpdateBusinesses(List<IBusiness> businesses, String userId,
      {Realm? localRealm, required bool usenewVersion}) async {
    final List<Business> businessesToAdd = [];
    if (!usenewVersion) {
      for (IBusiness business in businesses) {
        Business biz = Business(
          ObjectId(),
          userId: business.userId,
          serverId: business.id,
          name: business.name,
          currency: business.currency,
          categoryId: business.categoryId,
          latitude: business.latitude,
          longitude: business.longitude,
          timeZone: business.timeZone,
          country: business.country,
          businessUrl: business.businessUrl,
          hexColor: business.hexColor,
          imageUrl: business.imageUrl,
          type: business.type,
          active: business.active,
          chatUid: business.chatUid,
          metadata: business.metadata,
          role: business.role,
          lastSeen: business.lastSeen,
          firstName: business.firstName,
          lastName: business.lastName,
          createdAt: business.createdAt,
          deviceToken: business.deviceToken,
          backUpEnabled: business.backUpEnabled,
          subscriptionPlan: business.subscriptionPlan,
          nextBillingDate: business.nextBillingDate,
          previousBillingDate: business.previousBillingDate,
          isLastSubscriptionPaymentSucceeded:
              business.isLastSubscriptionPaymentSucceeded,
          backupFileId: business.backupFileId,
          email: business.email,
          lastDbBackup: business.lastDbBackup,
          fullName: business.fullName,
          tinNumber: business.tinNumber,
          bhfId: "00",
          dvcSrlNo: business.dvcSrlNo,
          adrs: business.adrs,
          taxEnabled: business.taxEnabled,
          taxServerUrl: business.taxServerUrl,
          isDefault: business.isDefault,
          businessTypeId: business.businessTypeId,
          lastTouched: business.lastTouched,
          deletedAt: business.deletedAt,
          encryptionKey: business.encryptionKey,
        );

        Business? exist = localRealm!
            .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
        if (exist == null) {
          businessesToAdd.add(biz);
        }
      }

      localRealm!.writeAsync(() {
        localRealm.addAll<Business>(businessesToAdd);
      });
    } else {
      for (IBusiness business in businesses) {
        final doc = await ProxyService.capela.businessCollection
            ?.document(business.id.toString());
        if (doc == null) {
          final odm.Business iBusiness = odm.Business(
            serverId: business.id,
            name: business.name,
            currency: business.currency,
            categoryId: business.categoryId,
            latitude: business.latitude,
            longitude: business.longitude,
            userId: business.userId,
            timeZone: business.timeZone,
            country: business.country,
            businessUrl: business.businessUrl,
            hexColor: business.hexColor,
            imageUrl: business.imageUrl,
            type: business.type,
            active: business.active,
            chatUid: business.chatUid,
            metadata: business.metadata,
            role: business.role,
            lastSeen: business.lastSeen,
            firstName: business.firstName,
            lastName: business.lastName,
            createdAt: business.createdAt,
            deviceToken: business.deviceToken,
            backUpEnabled: business.backUpEnabled,
            subscriptionPlan: business.subscriptionPlan,
            nextBillingDate: business.nextBillingDate,
            previousBillingDate: business.previousBillingDate,
            isLastSubscriptionPaymentSucceeded:
                business.isLastSubscriptionPaymentSucceeded,
            backupFileId: business.backupFileId,
            email: business.email,
            lastDbBackup: business.lastDbBackup,
            fullName: business.fullName,
            tinNumber: business.tinNumber,
            bhfId: business.bhfId,
            dvcSrlNo: business.dvcSrlNo,
            adrs: business.adrs,
            taxEnabled: business.taxEnabled,
            taxServerUrl: business.taxServerUrl,
            isDefault: business.isDefault,
            businessTypeId: business.businessTypeId,
            deletedAt: business.deletedAt,
          );
          var doc = MutableDocument.withId(
              iBusiness.serverId.toString(), iBusiness.toJson());
          ProxyService.capela.businessCollection?.saveDocument(doc);
        }
      }
    }
  }

  Future<void> handleLoginError(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  Future<void> setDefaultApp(IUser user, {Realm? localRealm}) async {
    final String defaultAppValue = user.tenants.isEmpty
        ? 'null'
        : ProxyService.box.getDefaultApp() != "1"
            ? ProxyService.box.getDefaultApp()
            : user.tenants.first.businesses.first.businessTypeId.toString();

    await ProxyService.box
        .writeString(key: 'defaultApp', value: defaultAppValue);
  }

  Future<void> configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    await ProxyService.box.writeString(key: 'bearerToken', value: user.token);

    /// FIXME: should set branchId and businessId by looking into what is set to be default
    /// when we enable for a user to login on multiple

    talker.warning("Upon login: UserId ${user.id}: UserPhone: ${userPhone}");

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(key: 'uid', value: user.uid ?? "");
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);

    if (user.tenants.isEmpty) {
      talker.error("User created does not have tenants");
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    if (user.tenants.first.businesses.isEmpty ||
        user.tenants.first.branches.isEmpty) {
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }

    /// find admin permission in permission list from yegobox
    for (IPermission permission in user.tenants.first.permissions) {
      if (permission == 'admin') {
        ProxyService.box.writeString(
            key: 'yegoboxLoggedInUserPermission',
            value: user.tenants.first.permissions.first.name);
      }
    }

    await ProxyService.box.writeInt(
        key: 'branchId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.branches.first.id!);

    await ProxyService.box.writeInt(
        key: 'businessId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id!);
    await ProxyService.box.writeString(
        key: 'encryptionKey',
        value: user.tenants.first.businesses.first.encryptionKey);
  }

  Future<void> initializeRealms() async {
    if (ProxyService.local.realm == null) {
      await ProxyService.local
          .configureLocal(useInMemory: false, box: ProxyService.box);
    }
  }
}
