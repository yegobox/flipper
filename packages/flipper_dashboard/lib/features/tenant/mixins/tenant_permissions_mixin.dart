import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class TenantPermissionsMixin {
  static Future<void> savePermissionsStatic(
    Tenant? newTenant,
    Business? business,
    Branch? branch,
    String userType,
    Map<String, String> tenantAllowedFeatures,
    Map<String, bool> activeFeatures,
    int? userId,
  ) async {
    tenantAllowedFeatures.forEach((featureName, accessLevel) async {
      List<Access> existingAccess = await ProxyService.strategy.access(
          userId: newTenant?.userId ?? userId!, featureName: featureName);
      talker.warning(featureName);
      if (existingAccess.isNotEmpty) {
        ProxyService.strategy.updateAccess(
          accessId: existingAccess.first.id,
          userId: newTenant?.userId ?? userId!,
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
        ProxyService.strategy.addAccess(
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
    });
  }

  static void fillFormWithTenantDataStatic(
    Tenant tenant,
    List<Access> tenantAccesses,
    void Function(void Function()) setState,
    Map<String, String> tenantAllowedFeatures,
    Map<String, bool> activeFeatures,
    String selectedUserType,
    TextEditingController nameController,
    TextEditingController phoneController,
    GlobalKey<FormState> formKey,
  ) {
    setState(() {
      tenantAllowedFeatures.clear();
      activeFeatures.clear();
      String? userType;

      for (var access in tenantAccesses) {
        if (access.featureName != null && access.accessLevel != null) {
          String validAccessLevel = accessLevels.contains(access.accessLevel)
              ? access.accessLevel!
              : 'No Access';
          tenantAllowedFeatures[access.featureName!] = validAccessLevel;
          activeFeatures[access.featureName!] = access.status == 'active';

          if (userType == null && access.userType != null) {
            userType = access.userType;
          }
        }
      }

      for (String feature in features) {
        if (!tenantAllowedFeatures.containsKey(feature)) {
          tenantAllowedFeatures[feature] = 'No Access';
        }
        if (!activeFeatures.containsKey(feature)) {
          activeFeatures[feature] = false;
        }
      }
    });

    nameController.text = tenant.name ?? '';
    phoneController.text = tenant.phoneNumber ?? '';

    if (formKey.currentContext != null) {
      Form.of(formKey.currentContext!).reset();
    }

    if (formKey.currentContext != null) {
      Scrollable.ensureVisible(
        formKey.currentContext!,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  static void updateTenantPermissionsStatic(
    List<Access> tenantAccesses,
    void Function(void Function()) setState,
    Map<String, String> tenantAllowedFeatures,
  ) {
    setState(() {
      tenantAllowedFeatures.clear();
      for (Access access in tenantAccesses) {
        if (access.featureName != null && access.accessLevel != null) {
          tenantAllowedFeatures[access.featureName!] = access.accessLevel!;
        }
      }
    });
  }

  static Widget buildPermissionsSectionStatic(
    BuildContext context,
    Map<String, String> tenantAllowedFeatures,
    Map<String, bool> activeFeatures,
    void Function(void Function()) setState,
  ) {
    return Column(
      children: features.map((feature) {
        return buildPermissionRowStatic(
          context,
          feature,
          tenantAllowedFeatures,
          activeFeatures,
          setState,
        );
      }).toList(),
    );
  }

  static Widget buildPermissionRowStatic(
    BuildContext context,
    String feature,
    Map<String, String> tenantAllowedFeatures,
    Map<String, bool> activeFeatures,
    void Function(void Function()) setState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: tenantAllowedFeatures[feature] ?? 'No Access',
              onChanged: (String? newValue) {
                setState(() {
                  tenantAllowedFeatures[feature] = newValue!;
                });
              },
              items: accessLevels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          SizedBox(width: 16),
          Switch(
            value: activeFeatures[feature] ?? false,
            onChanged: (bool value) {
              setState(() {
                if (!tenantAllowedFeatures.containsKey(feature)) {
                  tenantAllowedFeatures[feature] = 'write';
                }
                activeFeatures[feature] = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
