import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';

class TenantPermissionsMixin {
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
    // Reset the form using the form key directly instead of Form.of()
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }

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
    phoneController.text = tenant.phoneNumber ?? tenant.email ?? '';

    // Note: Removed Scrollable.ensureVisible to avoid context issues when called from expansion tile
    // The form reset functionality works without scrolling in this context
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: features.asMap().entries.map((entry) {
          int idx = entry.key;
          String feature = entry.value;
          return Column(
            children: [
              buildPermissionRowStatic(
                context,
                feature,
                tenantAllowedFeatures,
                activeFeatures,
                setState,
              ),
              if (idx < features.length - 1)
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            ],
          );
        }).toList(),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: tenantAllowedFeatures[feature] ?? 'No Access',
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            activeColor: Colors.blueAccent,
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
