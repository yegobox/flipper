import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';

import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

mixin Booting {
  final talker = TalkerFlutter.init();

  Future<void> updateLocalRealm(IUser user, {Realm? localRealm}) async {
    for (ITenant tenant in user.tenants) {
      await _addOrUpdateTenant(tenant, user.id.toString(),
          localRealm: localRealm);
    }
  }

  Future<void> _addOrUpdateTenant(ITenant tenant, String userId,
      {Realm? localRealm}) async {
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

    await addOrUpdateBusinesses(tenant.businesses, userId,
        localRealm: localRealm);
    await addOrUpdateBranches(tenant.branches, localRealm: localRealm);
    await addOrUpdatePermissions(tenant.permissions, localRealm: localRealm);
    await addOrUpdateTenantInRealm(iTenant, userId, localRealm: localRealm);
  }

  Future<void> addOrUpdateTenantInRealm(Tenant iTenant, String userId,
      {Realm? localRealm}) async {
    Tenant? exist = ProxyService.realm.realm!
        .query<Tenant>(r'id == $0', [iTenant.id]).firstOrNull;
    if (exist == null) {
      ProxyService.realm.realm!.write(() {
        iTenant.sessionActive = (userId == iTenant.userId);
        ProxyService.realm.realm!.add<Tenant>(iTenant);
      });
    }
  }

  Future<void> addOrUpdatePermissions(List<IPermission> permissions,
      {Realm? localRealm}) async {
    final List<LPermission> permissionToAdd = [];
    final List<String> features = ['Sales', 'Inventory', 'Reports', 'Settings'];

    for (IPermission permission in permissions) {
      LPermission? exist = ProxyService.realm.realm!
          .query<LPermission>(r'userId == $0', [permission.userId]).firstOrNull;

      if (exist == null) {
        final perm = LPermission(
          ObjectId(),
          id: randomNumber(),
          name: permission.name,
          userId: permission.userId,
        );
        permissionToAdd.add(perm);

        // Check if the permission is "admin" and handle access creation
        if (permission.name.toLowerCase() == 'admin') {
          for (String featureName in features) {
            final Access? existingAccess = ProxyService.realm.realm!
                .query<Access>(r'userId == $0 AND featureName == $1',
                    [permission.userId, featureName]).firstOrNull;

            if (existingAccess == null) {
              final Access access = Access(
                ObjectId(),
                id: randomNumber(),
                createdAt: DateTime.now(),
                branchId: ProxyService.box.getBranchId(),
                businessId: ProxyService.box.getBusinessId(),
                userType: "Admin",
                accessLevel: 'Admin'.toLowerCase(),
                status: 'active',
                userId: permission.userId,
                featureName: featureName,
              );
              ProxyService.realm.realm!.write(() {
                ProxyService.realm.realm!.add<Access>(access);
              });
            }
          }
        }
      }
    }

    ProxyService.realm.realm!.write(() {
      ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
    });
  }

  Future<void> addOrUpdateBranches(List<IBranch> branches,
      {Realm? localRealm}) async {
    final List<Branch> branchToAdd = [];

    for (IBranch brannch in branches) {
      Branch branch = Branch(
        ObjectId(),
        id: randomNumber(),
        serverId: brannch.id,
        description: brannch.description,
        name: brannch.name,
        businessId: brannch.businessId,
        longitude: brannch.longitude,
        latitude: brannch.latitude,

        /// when we are loading branch from remove we ignore the default behaviour of a user
        /// what is set to be default branch
        isDefault: false,
        active: false,
        lastTouched: brannch.lastTouched,
        action: brannch.action,
        deletedAt: brannch.deletedAt,
      );

      Branch? exist = localRealm!
          .query<Branch>(r'serverId == $0', [branch.serverId]).firstOrNull;
      if (exist == null) {
        branchToAdd.add(branch);
      }
    }

    localRealm!.write(() {
      localRealm.addAll<Branch>(branchToAdd);
    });
  }

  Future<void> addOrUpdateBusinesses(List<IBusiness> businesses, String userId,
      {Realm? localRealm}) async {
    final List<Business> businessesToAdd = [];

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
        bhfId: ProxyService.box.bhfId() ?? "00",
        dvcSrlNo: business.dvcSrlNo,
        adrs: business.adrs,
        taxEnabled: business.taxEnabled,
        taxServerUrl: business.taxServerUrl,
        isDefault: business.isDefault,
        businessTypeId: business.businessTypeId,
        lastTouched: business.lastTouched,
        action: business.action,
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
    if (ProxyService.realm.realm == null) {
      await ProxyService.realm.configure(
        useInMemoryDb: false,
        useFallBack: false,
        localRealm: ProxyService.local.localRealm,
        businessId: ProxyService.box.getBusinessId(),
        encryptionKey: ProxyService.box.encryptionKey(),
        branchId: ProxyService.box.getBranchId(),
        userId: ProxyService.box.getUserId(),
      );
    }
    if (ProxyService.local.localRealm == null) {
      await ProxyService.local.configureLocal(useInMemory: false);
    }
  }
}
