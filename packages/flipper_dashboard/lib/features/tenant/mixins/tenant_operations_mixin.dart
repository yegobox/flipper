import 'dart:convert';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TenantOperationsMixin {
  // Helper function to display error messages
  static void _showError(BuildContext context, String message) {
    showCustomSnackBarUtil(context, message, backgroundColor: Colors.red[600]);
  }

  static Future<void> addUserStatic(
    FlipperBaseModel model,
    BuildContext context, {
    required bool editMode,
    required String name,
    required String phone,
    required String userType,
    required String? userId,
    required WidgetRef ref,
    required Map<String, String> tenantAllowedFeatures,
    required Map<String, bool> activeFeatures,
  }) async {
    try {
      Branch? branch;
      if (userType == 'Agent') {
        // Create a new branch for the agent
        branch = await ProxyService.strategy.addBranch(
          businessId: ProxyService.box.getBusinessId()!,
          name: name,
          location: name, // Using name for location as well
          isDefault: false,
          active: false,
          flipperHttpClient: ProxyService.http,
        );
      } else {
        // Use the selected or default branch for other user types
        branch =
            // ref.read(selectedBranchProvider) ??
            await ProxyService.strategy.activeBranch(
              businessId: ProxyService.box.getBusinessId()!,
            );
      }

      // Call the v2/api/user endpoint to get user information
      final userResponse = await ProxyService.http.post(
        Uri.parse('${AppSecrets.apihubProd}/v2/api/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phone, // phone can also be email
        }),
      );

      if (userResponse.statusCode != 200) {
        _showError(
          context,
          "Failed to find user with provided phone/email: ${userResponse.body}",
        );
        return;
      }

      final userJson = jsonDecode(userResponse.body);
      final String userIdFromApi = userJson['id'];
      final String phoneNumber = userJson['phone_number'];

      // Call Supabase RPC function to create agent
      final supabaseClient = Supabase.instance.client;

      // Prepare access permissions from tenantAllowedFeatures
      List<Map<String, String>> accessPermissions = [];
      for (final entry in tenantAllowedFeatures.entries) {
        accessPermissions.add({
          'feature_name': entry.key,
          'access_level': entry.value,
          'status':
              activeFeatures[entry.key] != null && activeFeatures[entry.key]!
              ? 'active'
              : 'inactive',
        });
      }

      // Log the data being sent to create_agent
      talker.info('Creating agent with data:');
      talker.info('  User ID: $userIdFromApi');
      talker.info('  Name: $name');
      talker.info('  Email/Phone: $phoneNumber');
      talker.info('  Business ID: ${branch.businessId}');
      talker.info('  Branch ID: ${branch.id}');
      talker.info('  Access Permissions: $accessPermissions');

      // Call the create_agent RPC function
      final data = await supabaseClient.rpc(
        'create_agent',
        params: {
          'p_user_id': userIdFromApi,
          'p_name': name,
          'p_email': phoneNumber, // Using phone number as email for now
          'p_business_id': branch.businessId,
          'p_branch_id': branch.id, // Can be null for non-agent users
          'p_accesses': accessPermissions,
        },
      );

      // Get the tenant ID returned by the RPC function
      final String tenantId = data;
      // query the agent on local for display
      await ProxyService.strategy.tenant(tenantId: tenantId, fetchRemote: true);

      // Generate pin for the new tenant
      final pinResponse = await ProxyService.http.post(
        Uri.parse('${AppSecrets.apihubProd}/v2/api/pin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phone,
          'userId': userIdFromApi,
          'branchId': branch.id,
          'businessId': branch.businessId,
          'defaultApp': 1,
        }),
      );

      if (pinResponse.statusCode != 200 && pinResponse.statusCode != 201) {
        _showError(
          context,
          "Failed to generate pin for the new tenant: ${pinResponse.body}",
        );
        return;
      }

      showCustomSnackBarUtil(context, 'Tenant Created Successfully via RPC');

      // Refresh the tenant list
      await model.loadTenants();
    } on DuplicateTenantException catch (e) {
      // Handle duplicate tenant error with a user-friendly message
      showCustomSnackBarUtil(
        context,
        e.message,
        backgroundColor: Colors.orange[700],
      );
      rethrow; // Re-throw to allow the calling widget to handle the error as well
    } catch (e, s) {
      talker.error(s);
      showCustomSnackBarUtil(
        context,
        "An unexpected error occurred: ${e.toString()}",
        backgroundColor: Colors.red[600],
      );
      rethrow; // Re-throw to allow the calling widget to handle the error as well
    }
  }

  static Future<void> deleteTenantStatic(
    Tenant tenant,
    FlipperBaseModel model,
    BuildContext context,
  ) async {
    try {
      // Delete the tenant
      await ProxyService.strategy.flipperDelete(
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
    Future<void> Function(Tenant, FlipperBaseModel, BuildContext) onDelete,
  ) {
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
