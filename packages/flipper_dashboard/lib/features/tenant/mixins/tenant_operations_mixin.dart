import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';

class TenantOperationsMixin {
  // Helper function to display error messages
  static void _showError(BuildContext context, String message) {
    showCustomSnackBarUtil(context, message, backgroundColor: Colors.red[600]);
  }

  static Future<void> savePermissionsStatic(
    Tenant? newTenant,
    Business? business,
    Branch? branch,
    String userType,
    Map<String, String> tenantAllowedFeatures,
    Map<String, bool> activeFeatures,
    int? userId,
  ) async {
    for (final entry in tenantAllowedFeatures.entries) {
      final featureName = entry.key;
      final accessLevel = entry.value;
      List<Access> existingAccess = await ProxyService.strategy.access(
          fetchRemote: false,
          userId: newTenant?.userId ?? userId!,
          featureName: featureName);
      talker.warning(featureName);
      if (existingAccess.isNotEmpty) {
        ProxyService.strategy.updateAccess(
          accessId: existingAccess.first.id,
          userId: newTenant?.userId ?? userId!,
          branchId: branch!.serverId!,
          businessId: business!.serverId,
          featureName: featureName,
          accessLevel: accessLevel.toLowerCase(),
          status: activeFeatures[featureName] != null
              ? activeFeatures[featureName]!
                  ? 'active'
                  : 'inactive'
              : 'inactive',
          userType: userType,
        );
      } else {
        await ProxyService.strategy.addAccess(
            branchId: branch!.serverId!,
            businessId: business!.serverId,
            userId: newTenant?.userId ?? userId!,
            featureName: featureName,
            accessLevel: accessLevel.toLowerCase(),
            status: activeFeatures[featureName] != null
                ? activeFeatures[featureName]!
                    ? 'active'
                    : 'inactive'
                : 'inactive',
            userType: userType);
      }
    }
    // save tenant
    await ProxyService.strategy.updateTenant(
      userId: newTenant?.userId ?? userId!,
      type: userType,
    );
  }

  static Future<void> addUserStatic(
    FlipperBaseModel model,
    BuildContext context, {
    required bool editMode,
    required String name,
    required String phone,
    required String userType,
    required int? userId,
    required WidgetRef ref,
    required Map<String, String> tenantAllowedFeatures,
    required Map<String, bool> activeFeatures,
  }) async {
    try {
      Business? business = await ProxyService.strategy.defaultBusiness();
      Branch? branch = ref.read(selectedBranchProvider) ??
          await ProxyService.strategy.defaultBranch();

      if (business == null || branch == null) {
        showCustomSnackBarUtil(context, 'Business or Branch not found',
            backgroundColor: Colors.red[600]);
        return;
      }

      Tenant? newTenant;
      if (!editMode) {
        // Creating a new tenant
        newTenant = await ProxyService.strategy.addNewTenant(
          name: name,
          phoneNumber: phone,
          branch: branch,
          business: business,
          userType: userType,
          flipperHttpClient: ProxyService.http,
        );
        showCustomSnackBarUtil(context, 'Tenant Created Successfully');
        // save this tenant to supabase
        await ProxyService.strategy.updateTenant(
          tenantId: newTenant!.id,
          name: name,
          phoneNumber: newTenant.phoneNumber,
          email: '',
          userId: newTenant.userId,
          businessId: business.serverId,
          type: userType,
          pin: newTenant.userId,
          sessionActive: true,
        );
      } else {
        // Fetching an existing tenant for editing
        newTenant = await ProxyService.strategy.getTenant(userId: userId);
      }

      if (newTenant == null) {
        _showError(context, "Failed to create or fetch tenant.");
        return;
      }

      // Save permissions with correct values
      await savePermissionsStatic(
        newTenant,
        business,
        branch,
        userType,
        tenantAllowedFeatures,
        activeFeatures,
        newTenant.userId,
      );
      showCustomSnackBarUtil(context, 'Tenant Updated or Created Successfully');

      // Refresh the tenant list
      await model.loadTenants();
    } catch (e, s) {
      talker.error(s);
      showCustomSnackBarUtil(
          context, "An unexpected error occurred: ${e.toString()}",
          backgroundColor: Colors.red[600]);
      rethrow; // Re-throw to allow the calling widget to handle the error as well
    }
  }

  static Future<void> deleteTenantStatic(
      Tenant tenant, FlipperBaseModel model, BuildContext context) async {
    try {
      // Delete the tenant
      await ProxyService.strategy.delete(
        id: tenant.id,
        endPoint: 'tenant',
        flipperHttpClient: ProxyService.http,
      );

      // Delete associated permissions
      //TODO: Resume this later since we are migrating to common db, in future deleting this local will do the same to the backend.
      // List<LPermission> permissions =
      //     await ProxyService.strategy.permissions(userId: tenant.userId!);
      // for (LPermission permission in permissions) {
      //   await ProxyService.strategy.delete(
      //     id: permission.id,
      //     endPoint: 'permission',
      //     flipperHttpClient: ProxyService.http,
      //   );
      // }

      // Delete associated accesses
      // List<Access> accesses = await ProxyService.strategy
      //     .access(userId: tenant.userId!, fetchRemote: false);
      // for (Access access in accesses) {
      //   await ProxyService.strategy.delete(
      //     id: access.id,
      //     endPoint: 'access',
      //     flipperHttpClient: ProxyService.http,
      //   );
      // }

      model.deleteTenant(tenant); // Update local state
      model.rebuildUi(); // Rebuild the UI

      showCustomSnackBarUtil(context, 'Tenant deleted successfully');
    } catch (e) {
      talker.error("Error deleting tenant: $e"); // Log the error
      _showError(context, 'Error deleting tenant. Please try again.');
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
          title: const Text("Delete Tenant"),
          content: const Text("Are you sure you want to delete this tenant?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await onDelete(tenant, model, context); // Await the deletion
              },
              child: const Text("Delete"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
