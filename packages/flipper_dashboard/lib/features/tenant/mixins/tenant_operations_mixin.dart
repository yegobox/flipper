import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TenantOperationsMixin {
  static Future<void> addUserStatic(
    FlipperBaseModel model,
    BuildContext context, {
    required bool editMode,
    required String name,
    required String phone,
    required String userType,
    required int? userId,
    required WidgetRef ref,
  }) async {
    try {
      Business? business = await ProxyService.strategy.defaultBusiness();
      Branch? branch = ref.read(selectedBranchProvider) ??
          await ProxyService.strategy.defaultBranch();

      Tenant? newTenant;
      if (!editMode) {
        newTenant = await ProxyService.strategy.saveTenant(
            name: name,
            phoneNumber: phone,
            branch: branch!,
            business: business!,
            userType: userType,
            flipperHttpClient: ProxyService.http);
      } else {
        newTenant = await ProxyService.strategy.getTenant(userId: userId!);
      }

      updateTenantStatic(
          tenant: newTenant,
          name: name,
          type: userType);

      await model.loadTenants();
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  static void updateTenantStatic({Tenant? tenant, String? name, required String type}) {
    try {
      if (name != null && !name.isEmpty) {
        ProxyService.strategy.updateTenant(
          tenantId: tenant!.id,
          name: name,
          type: type,
          pin: tenant.userId,
        );
      }
    } catch (e) {
      talker.error(e);
    }
  }

  static Future<void> deleteTenantStatic(
      Tenant tenant, FlipperBaseModel model, BuildContext context) async {
    try {
      model.deleteTenant(tenant);

      showToast(context, 'Tenant deleted successfully');
      model.deleteTenant(tenant);
      ProxyService.strategy.delete(
          id: tenant.id,
          endPoint: 'tenant',
          flipperHttpClient: ProxyService.http);

      List<LPermission> permissions =
          await ProxyService.strategy.permissions(userId: tenant.userId!);
      for (LPermission permission in permissions) {
        ProxyService.strategy.delete(
            id: permission.id,
            endPoint: 'permission',
            flipperHttpClient: ProxyService.http);
      }

      List<Access> accesses =
          await ProxyService.strategy.access(userId: tenant.userId!);
      for (Access access in accesses) {
        ProxyService.strategy.delete(
            id: access.id,
            endPoint: 'access',
            flipperHttpClient: ProxyService.http);
      }

      model.rebuildUi();
    } catch (e) {
      showToast(context, 'Error deleting tenant');
    }
  }

  static void showDeleteConfirmationStatic(
      BuildContext context,
      Tenant tenant,
      FlipperBaseModel model,
      Future<void> Function(Tenant, FlipperBaseModel, BuildContext) onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Tenant"),
          content: Text("Are you sure you want to delete this tenant?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(tenant, model, context);
              },
              child: Text("Delete"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
