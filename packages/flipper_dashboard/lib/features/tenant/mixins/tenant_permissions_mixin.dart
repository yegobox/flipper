import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _kTenantAccentBlue = Color(0xff006AFE);

class TenantPermissionsMixin {
  /// Maps Supabase values (e.g. read_write) to [accessLevels] entries for dropdowns.
  static String normalizeAccessLevelForUi(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'No Access';
    final v = raw.trim();
    if (accessLevels.contains(v)) return v;
    switch (v.toLowerCase()) {
      case 'read_write':
      case 'readwrite':
        return 'write';
      case 'read-only':
      case 'readonly':
        return 'read';
      case 'none':
      case 'no_access':
      case 'no access':
        return 'No Access';
      default:
        break;
    }
    final lower = v.toLowerCase();
    for (final level in accessLevels) {
      if (level.toLowerCase() == lower) return level;
    }
    return 'No Access';
  }

  static Color featureModuleDotColor(int index) {
    const dots = <Color>[
      Color(0xff006AFE),
      Color(0xFF6B4EA2),
      Color(0xFFE08A2E),
      Color(0xFF2E7D32),
      Color(0xFF0D9488),
      Color(0xFF1565C0),
      Color(0xFFAD1457),
      Color(0xFF5D4037),
    ];
    return dots[index % dots.length];
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
          final normalized = normalizeAccessLevelForUi(access.accessLevel);
          tenantAllowedFeatures[access.featureName!] = normalized;
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
          tenantAllowedFeatures[access.featureName!] =
              normalizeAccessLevelForUi(access.accessLevel);
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'MODULE PERMISSIONS',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'MODULE',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'ACCESS LEVEL',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        'ACTIVE',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...features.asMap().entries.map((entry) {
                final idx = entry.key;
                final feature = entry.value;
                return Column(
                  children: [
                    if (idx > 0)
                      Divider(color: Colors.grey[200], height: 1),
                    buildPermissionRowStatic(
                      context,
                      idx,
                      feature,
                      tenantAllowedFeatures,
                      activeFeatures,
                      setState,
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildPermissionRowStatic(
    BuildContext context,
    int featureIndex,
    String feature,
    Map<String, String> tenantAllowedFeatures,
    Map<String, bool> activeFeatures,
    void Function(void Function()) setState,
  ) {
    final raw = tenantAllowedFeatures[feature] ?? 'No Access';
    final dropdownValue = accessLevels.contains(raw)
        ? raw
        : normalizeAccessLevelForUi(raw);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: featureModuleDotColor(featureIndex),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      tenantAllowedFeatures[feature] = newValue!;
                    });
                  },
                  items: accessLevels.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.outfit(fontSize: 13)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Center(
              child: Switch.adaptive(
                activeTrackColor: _kTenantAccentBlue.withValues(alpha: 0.45),
                thumbColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? _kTenantAccentBlue
                      : null,
                ),
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
            ),
          ),
        ],
      ),
    );
  }
}
