import 'dart:convert';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TenantOperationsMixin {
  // Helper function to display error messages
  static void _showError(BuildContext context, String message) {
    showCustomSnackBarUtil(context, message, backgroundColor: Colors.red[600]);
  }

  static Never _fail(BuildContext context, String message, [Object? error]) {
    _showError(context, message);
    throw Exception(error ?? message);
  }

  static String? _normalizeAccessLevelForApi(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    if (v == 'No Access') return null;
    switch (v.toLowerCase()) {
      case 'read':
      case 'write':
      case 'admin':
        return v.toLowerCase();
      // Some older values can appear in DB; map them safely.
      case 'read_write':
      case 'readwrite':
        return 'write';
      default:
        return null;
    }
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
    Map<String, String>? permissionsBaseline,
    Map<String, bool>? activeFeaturesBaseline,
  }) async {
    try {
      Branch? branch;
      // IMPORTANT: do NOT create a new branch here.
      // We need a branch that already exists in Supabase; otherwise create_agent
      // fails with "Branch ... does not belong to business ..." (it checks existence
      // + business_id match).
      //
      // Agents can still be created under the *current* active branch.
      final currentBranchId = ProxyService.box.getBranchId();
      if (currentBranchId == null || currentBranchId.isEmpty) {
        _fail(context, 'branch_id can not be null');
      }
      branch = await ProxyService.strategy.activeBranch(branchId: currentBranchId);

      final businessIdFromBox = ProxyService.box.getBusinessId();
      if (businessIdFromBox == null || businessIdFromBox.isEmpty) {
        _fail(context, 'business_id can not be null');
      }

      talker.info(
        'addUserStatic: context ids → businessId=$businessIdFromBox, branchId=${branch.id}, branch.businessId=${branch.businessId}, userType=$userType, editMode=$editMode',
      );
      debugPrint(
        'addUserStatic ids: businessId=$businessIdFromBox branchId=${branch.id} branch.businessId=${branch.businessId} userType=$userType editMode=$editMode',
      );

      // Guardrail: ensure selected branch belongs to the current business.
      // This prevents create_agent from failing with "branch does not belong".
      try {
        final branchRow = await Supabase.instance.client
            .from('branches')
            .select('id,business_id')
            .eq('id', branch.id)
            .maybeSingle();
        if (branchRow == null) {
          // Could be RLS filtering the row; don't block, just log and let RPC decide.
          talker.warning(
            'addUserStatic: branches lookup returned null for branchId=${branch.id}. Skipping guardrail (possible RLS/offline).',
          );
          debugPrint(
            'addUserStatic: branches lookup returned null for branchId=${branch.id}',
          );
        } else {
          final branchBusinessId = branchRow['business_id']?.toString();
          talker.info(
            'addUserStatic: branches.business_id for branchId=${branch.id} is $branchBusinessId (current businessId=$businessIdFromBox)',
          );
          debugPrint(
            'addUserStatic: branches.business_id for branchId=${branch.id} is $branchBusinessId (current businessId=$businessIdFromBox)',
          );
          if (branchBusinessId != null &&
              branchBusinessId.isNotEmpty &&
              branchBusinessId != businessIdFromBox) {
            _fail(
              context,
              'Selected branch does not belong to current business. Please switch business/branch and try again.',
            );
          }
        }
      } catch (e) {
        // If the guardrail query fails (offline), let the RPC decide.
        talker.warning('addUserStatic: branch guardrail query failed: $e');
        debugPrint('addUserStatic: branch guardrail query failed: $e');
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
        _fail(
          context,
          "Failed to find user with provided phone/email: ${userResponse.body}",
        );
      }

      final userJson = jsonDecode(userResponse.body);
      final String userIdFromApi = userJson['id'];
      final String phoneNumber = userJson['phone_number'];

      // Call Supabase RPC function to create agent
      final supabaseClient = Supabase.instance.client;

      // Prepare access permissions: on edit, only send rows that changed vs baseline
      // (new users still send the full map from tenantAllowedFeatures).
      List<Map<String, String>> accessPermissions = [];
      if (editMode &&
          permissionsBaseline != null &&
          activeFeaturesBaseline != null) {
        final seen = <String>{};
        for (final feature in features) {
          if (!seen.add(feature)) {
            continue;
          }
          final level =
              tenantAllowedFeatures[feature] ?? 'No Access';
          final active = activeFeatures[feature] ?? false;
          final baseLevel = permissionsBaseline[feature] ?? 'No Access';
          final baseActive = activeFeaturesBaseline[feature] ?? false;
          if (level == baseLevel && active == baseActive) {
            continue;
          }
          final normalized = _normalizeAccessLevelForApi(level);
          // If user set "No Access" or toggled inactive, persist as inactive.
          // We still send a stable access_level value to avoid writing arbitrary strings
          // like "No Access" into the DB column.
          accessPermissions.add({
            'feature_name': feature,
            'access_level': normalized ?? 'read',
            'status': (active && normalized != null) ? 'active' : 'inactive',
          });
        }
      } else {
        for (final entry in tenantAllowedFeatures.entries) {
          final normalized = _normalizeAccessLevelForApi(entry.value);
          final active = activeFeatures[entry.key] ?? false;
          // For new users, do not send "No Access" rows at all.
          if (normalized == null || !active) continue;
          accessPermissions.add({
            'feature_name': entry.key,
            'access_level': normalized,
            'status': 'active',
          });
        }
      }

      // Log the data being sent to create_agent
      talker.info('Creating agent with data:');
      talker.info('  User ID: $userIdFromApi');
      talker.info('  Name: $name');
      talker.info('  Email/Phone: $phoneNumber');
      talker.info('  Business ID: $businessIdFromBox');
      talker.info('  Branch ID: ${branch.id}');
      talker.info('  Access Permissions: $accessPermissions');

      // Call the create_agent RPC function
      dynamic data;
      try {
        final rpcParams = {
          'p_user_id': userIdFromApi,
          'p_name': name,
          'p_email': phoneNumber,
          'p_business_id': businessIdFromBox,
          'p_branch_id': branch.id,
          'p_accesses': accessPermissions,
        };
        talker.info('create_agent params: $rpcParams');
        data = await supabaseClient.rpc(
          'create_agent',
          params: rpcParams,
        );
      } on PostgrestException catch (e, s) {
        talker.error(s);
        _fail(
          context,
          e.message.isNotEmpty
              ? e.message
              : 'Failed to save permissions (Supabase error).',
          e,
        );
      } catch (e, s) {
        talker.error(s);
        _fail(context, 'Failed to save permissions: $e', e);
      }

      // Get the tenant ID returned by the RPC function (PostgREST can return
      // a JSON string, or a 1-row json list depending on headers).
      final String tenantId = switch (data) {
        final String v => v,
        final List v when v.isNotEmpty => v.first.toString(),
        _ => data.toString(),
      };
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
          'businessId': businessIdFromBox,
          'defaultApp': 1,
          'ownerName': name,
        }),
      );

      if (pinResponse.statusCode != 200 && pinResponse.statusCode != 201) {
        _fail(
          context,
          "Failed to generate pin for the new tenant: ${pinResponse.body}",
        );
      }

      await model.loadTenants();

      String successMessage;
      if (!editMode) {
        successMessage = 'Tenant Created Successfully';
      } else {
        successMessage =
            'Permissions saved. Other users update automatically when online (or after sign-in).';
        final selfId = ProxyService.box.getUserId();
        if (selfId != null &&
            selfId == userIdFromApi &&
            context.mounted) {
          final loginKey = ProxyService.box.getUserPhone() ?? phone;
          try {
            await ProxyService.strategy.sendLoginRequest(
              loginKey,
              ProxyService.http,
              AppSecrets.apihubProd,
            );
          } catch (e, s) {
            talker.warning('sendLoginRequest after permission edit: $e\n$s');
          }
          ref.invalidate(allAccessesProvider(userIdFromApi));
          for (final f in features) {
            ref.invalidate(
              userAccessesProvider(userIdFromApi, featureName: f),
            );
          }
          successMessage =
              'Permissions saved. Your menus have been refreshed.';
        }
      }

      if (context.mounted) {
        showCustomSnackBarUtil(context, successMessage);
      }
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
      // Call Supabase RPC function to remove tenant access
      final supabaseClient = Supabase.instance.client;
      await supabaseClient.rpc(
        'remove_tenant_access',
        params: {'p_tenant_id': tenant.id, 'p_business_id': tenant.businessId},
      );

      // Delete the tenant
      await ProxyService.strategy.flipperDelete(
        id: tenant.id,
        endPoint: 'tenant',
        flipperHttpClient: ProxyService.http,
      );

      model.deleteTenant(tenant); // Update local state
      model.rebuildUi(); // Rebuild the UI

      // Check if context is still valid before showing snackbar
      if (context.mounted) {
        showCustomSnackBarUtil(context, 'Tenant deleted successfully');
      }
    } catch (e) {
      talker.error("Error deleting tenant: $e"); // Log the error
      // Check if context is still valid before showing error
      if (context.mounted) {
        _showError(context, 'Error deleting tenant. Please try again.');
      }
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
