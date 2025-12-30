import 'package:collection/collection.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

mixin Booting {
  Future<void> addOrUpdatePermissions(List<IPermission> permissions,
      {required bool usenewVersion}) async {
    final List<String> features = ['Sales', 'Inventory', 'Reports', 'Settings'];
    // permissions = permissions.isEmpty? await ProxyService.strategy.permissions(userId: ProxyService.box.getUserId()!): permissions;
    /// check that all features above are saved with admin access
    /// TODO: improve this, because permission might be empty and the user logging in is not admin
    if (permissions.isEmpty) {
      /// if permissions are empty this means if it is not the first time we are logging in
      /// in this case we just need to check if all permission for admin were saved corectly
      for (String feature in features) {
        talker.warning(
            "Permission with userId: ${ProxyService.box.getUserId()!}");
        List<Access> hasAccess = await ProxyService.strategy.access(
            userId: ProxyService.box.getUserId()!,
            featureName: feature,
            fetchRemote: true);
        if (hasAccess.isEmpty) {
          await ProxyService.strategy.addAccess(
            branchId: ProxyService.box.getBranchId()!,
            businessId: ProxyService.box.getBusinessId()!,
            userId: ProxyService.box.getUserId()!,
            featureName: feature,
            accessLevel: 'Admin'.toLowerCase(),
            status: 'active',
            userType: "Admin",
          );
        }
      }
    }
  }

  Future<void> handleLoginErrorInBooting(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  Future<void> setDefaultApp(IUser user) async {
    final bool businessesEmpty = user.businesses?.isEmpty ?? true;
    final String defaultAppValue = businessesEmpty
        ? 'null'
        : ProxyService.box.getDefaultApp() != "POS"
            ? ProxyService.box.getDefaultApp() ?? "POS"
            : user.businesses!.first.businessTypeId.toString();

    await ProxyService.box
        .writeString(key: 'defaultApp', value: defaultAppValue);
  }

  Future<void> configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    await ProxyService.box
        .writeString(key: 'bearerToken', value: user.token ?? "");

    talker.warning("Upon login: UserId ${user.id}: UserPhone: ${userPhone}");

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(key: 'uid', value: user.uid ?? "");
    await ProxyService.box.writeString(key: 'userId', value: user.id);

    String? branchId = user.businesses?.firstOrNull?.branches?.firstOrNull?.id;
    String? businessId = user.businesses?.firstOrNull?.id;

    if (branchId == null) {
      // get any local saved branch
      Branch branch =
          await ProxyService.strategy.activeBranch(businessId: businessId!);
      branchId = branch.id;
    }

    // get any local saved business

    await ProxyService.box.writeString(key: 'branchId', value: branchId);

    if (businessId != null) {
      await ProxyService.box.writeString(key: 'businessId', value: businessId);
    }
    await ProxyService.box.writeString(
        key: 'encryptionKey',
        value: user.businesses?.firstOrNull?.encryptionKey ?? "");
  }
}
