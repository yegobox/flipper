import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TenantOperationsMixin {
  // Helper function to display error messages
  static void _showError(BuildContext context, String message) {
    showToast(context, message);
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
  }) async {
    try {
      Business? business = await ProxyService.strategy.defaultBusiness();
      Branch? branch = ref.read(selectedBranchProvider) ??
          await ProxyService.strategy.defaultBranch();

      if (business == null || branch == null) {
        _showError(context, "Default Business or Branch not found.");
        return;
      }

      Tenant? newTenant;
      if (!editMode) {
        // Creating a new tenant
        newTenant = await ProxyService.strategy.saveTenant(
          name: name,
          phoneNumber: phone,
          branch: branch,
          business: business,
          userType: userType,
          flipperHttpClient: ProxyService.http,
        );
        showToast(context, 'Tenant Created Successfully');
      } else {
        // Fetching an existing tenant for editing
        newTenant = await ProxyService.strategy.getTenant(userId: userId!);
        showToast(context, 'Tenant Fetched Successfully');
      }

      if (newTenant == null) {
        _showError(context, "Failed to create or fetch tenant.");
        return;
      }

      await updateTenantStatic(tenant: newTenant, name: name, type: userType);

      // Refresh the tenant list
      await model.loadTenants();
    } catch (e, s) {
      talker.error(s);
      _showError(context, "An unexpected error occurred: ${e.toString()}");
      rethrow; // Re-throw to allow the calling widget to handle the error as well
    }
  }

  static Future<void> updateTenantStatic({
    Tenant? tenant,
    String? name,
    required String type,
  }) async {
    try {
      if (tenant == null) {
        talker.warning("Tenant is null, cannot update.");
        return;
      }

      if (name != null && name.isNotEmpty) {
        await ProxyService.strategy.updateTenant(
          tenantId: tenant.id,
          name: name,
          type: type,
          pin: tenant.userId,
        );
        talker.info("Tenant updated successfully.");
      } else {
        talker.warning("Name is null or empty, skipping update.");
      }
    } catch (e) {
      talker.error(e);
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
      List<LPermission> permissions =
          await ProxyService.strategy.permissions(userId: tenant.userId!);
      for (LPermission permission in permissions) {
        await ProxyService.strategy.delete(
          id: permission.id,
          endPoint: 'permission',
          flipperHttpClient: ProxyService.http,
        );
      }

      // Delete associated accesses
      List<Access> accesses =
          await ProxyService.strategy.access(userId: tenant.userId!);
      for (Access access in accesses) {
        await ProxyService.strategy.delete(
          id: access.id,
          endPoint: 'access',
          flipperHttpClient: ProxyService.http,
        );
      }

      model.deleteTenant(tenant); // Update local state
      model.rebuildUi(); // Rebuild the UI

      showToast(context, 'Tenant deleted successfully');
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
