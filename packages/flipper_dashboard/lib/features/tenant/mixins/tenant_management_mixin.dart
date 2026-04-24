import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'tenant_form_mixin.dart';
import 'tenant_operations_mixin.dart';
import 'tenant_permissions_mixin.dart';
import 'tenant_ui_mixin.dart';

const Color _kUserMgmtAccent = Color(0xff006AFE);

mixin TenantManagementMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  final routerService = locator<RouterService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isAddingUser = false;
  bool editMode = false;
  String selectedUserType = 'Agent';
  Map<String, bool> activeFeatures = {};
  Map<String, String> tenantAllowedFeatures = {};
  /// Captured when opening a tenant for edit; used to send only changed accesses to `create_agent`.
  Map<String, String> _tenantPermissionsBaseline = {};
  Map<String, bool> _tenantActiveBaseline = {};
  bool _hasTenantPermissionBaseline = false;
  String? userId;
  Tenant? editedTenant;
  String _tenantListSearchQuery = '';
  String? selectedTenantUserId;

  Future<void> selectTenantForEdit(Tenant tenant, FlipperBaseModel model) async {
    final uid = tenant.userId;
    final tid = tenant.id;
    if (uid == null || uid.isEmpty) return;

    setState(() {
      selectedTenantUserId = uid;
    });

    try {
      final rows = await Supabase.instance.client
          .from('accesses')
          .select()
          .eq('user_id', uid)
          .eq('tenant_id', tid);

      final list = <Access>[];
      for (final item in rows as List<dynamic>) {
        final e = Map<String, dynamic>.from(item as Map);
        list.add(Access(
          id: e['id'] as String?,
          userId: e['user_id'] as String?,
          tenantId: e['tenant_id'] as String?,
          businessId: e['business_id'] as String?,
          branchId: e['branch_id'] as String?,
          featureName: e['feature_name'] as String?,
          userType: e['user_type'] as String?,
          accessLevel: e['access_level'] as String?,
          status: e['status'] as String?,
        ));
      }
      if (!mounted) return;
      fillFormWithTenantData(tenant, list);
    } catch (e, s) {
      debugPrint('selectTenantForEdit: $e\n$s');
      if (!mounted) return;
      fillFormWithTenantData(tenant, const []);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    setState(() {
      selectedUserType = 'Agent';
      tenantAllowedFeatures.clear();
      editMode = false;
      userId = null;
      editedTenant = null;
      selectedTenantUserId = null;
      _tenantListSearchQuery = '';
      _tenantPermissionsBaseline = {};
      _tenantActiveBaseline = {};
      _hasTenantPermissionBaseline = false;
    });
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
          color: Colors.grey[600],
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, color: Colors.grey[700], size: 22),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kUserMgmtAccent, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      ),
    );
  }

  Widget buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      key: ValueKey<String>('tenant_user_type_$selectedUserType'),
      initialValue: selectedUserType,
      onChanged: (String? newValue) {
        if (newValue == null) return;
        setState(() {
          selectedUserType = newValue;
        });
      },
      items: <String>['Agent', 'Cashier', 'Admin', 'Driver']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
            );
          })
          .toList(),
      decoration: InputDecoration(
        labelText: 'USER TYPE',
        labelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
          color: Colors.grey[600],
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.person_outline, color: Colors.grey[700], size: 22),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kUserMgmtAccent, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      ),
    );
  }

  Future<void> addUser(
    FlipperBaseModel model,
    BuildContext context, {
    required bool editMode,
    required String name,
    required String phone,
    required String userType,
    required String? userId,
  }) async {
    try {
      await TenantOperationsMixin.addUserStatic(
        model,
        context,
        editMode: editMode,
        name: name,
        phone: phone,
        userType: userType,
        userId: userId,
        ref: ref,
        tenantAllowedFeatures: tenantAllowedFeatures,
        activeFeatures: activeFeatures,
        permissionsBaseline:
            editMode && _hasTenantPermissionBaseline
                ? _tenantPermissionsBaseline
                : null,
        activeFeaturesBaseline:
            editMode && _hasTenantPermissionBaseline
                ? _tenantActiveBaseline
                : null,
      );
    } catch (error) {
      // Log the error to a logging service
      debugPrint('Error adding/updating user: $error');

      // Optionally, re-throw the error if you want the caller to handle it
      rethrow;
    }
  }

  Future<void> deleteTenant(
    Tenant tenant,
    FlipperBaseModel model,
    BuildContext context,
  ) async {
    return TenantOperationsMixin.deleteTenantStatic(tenant, model, context);
  }

  void showDeleteConfirmation(
    BuildContext context,
    Tenant tenant,
    FlipperBaseModel model,
  ) {
    TenantOperationsMixin.showDeleteConfirmationStatic(
      context,
      tenant,
      model,
      deleteTenant,
    );
  }

  void fillFormWithTenantData(Tenant tenant, List<Access> tenantAccesses) {
    TenantPermissionsMixin.fillFormWithTenantDataStatic(
      tenant,
      tenantAccesses,
      (fn) => setState(() {
        editMode = true;
        editedTenant = tenant;
        userId = tenant.userId;
        selectedUserType = tenant.type ?? 'Agent';
        fn();
      }),
      tenantAllowedFeatures,
      activeFeatures,
      selectedUserType,
      nameController,
      phoneController,
      formKey,
    );
    _tenantPermissionsBaseline = Map<String, String>.from(tenantAllowedFeatures);
    _tenantActiveBaseline = Map<String, bool>.from(activeFeatures);
    _hasTenantPermissionBaseline = true;
  }

  Widget buildPermissionsSection() {
    return TenantPermissionsMixin.buildPermissionsSectionStatic(
      context,
      tenantAllowedFeatures,
      activeFeatures,
      setState,
    );
  }

  Widget buildTenantsList(FlipperBaseModel model) {
    return TenantUIMixin.buildTenantsListStatic(
      context,
      model,
      buildTenantCard,
      _tenantListSearchQuery,
      (q) => setState(() => _tenantListSearchQuery = q),
    );
  }

  Widget buildTenantCard(Tenant tenant, FlipperBaseModel model) {
    return TenantUIMixin.buildTenantCardStatic(
      context,
      tenant,
      model,
      selectedTenantUserId != null && selectedTenantUserId == tenant.userId,
      (t) => selectTenantForEdit(t, model),
      showDeleteConfirmation,
    );
  }

  Widget buildBranchDropdown() {
    return TenantUIMixin.buildBranchDropdownStatic(context, ref);
  }

  Widget buildWideLayout(FlipperBaseModel model, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: buildAddTenantForm(model, context)),
        Container(
          width: 1,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          color: Colors.grey[200],
        ),
        Expanded(flex: 2, child: buildTenantsList(model)),
      ],
    );
  }

  Widget buildNarrowLayout(FlipperBaseModel model, BuildContext context) {
    return Column(
      children: [
        buildAddTenantForm(model, context),
        SizedBox(height: 20),
        buildTenantsList(model),
      ],
    );
  }

  Widget buildAddTenantForm(FlipperBaseModel model, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                editMode ? "Edit User" : "Add New User",
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              buildTextFormField(
                controller: nameController,
                labelText: "FULL NAME",
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              buildTextFormField(
                controller: phoneController,
                labelText: "PHONE / EMAIL",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: TenantFormMixin.validatePhoneOrEmailStatic,
              ),
              SizedBox(height: 16),
              buildUserTypeDropdown(),
              SizedBox(height: 16),
              if (selectedUserType != 'Agent') buildBranchDropdown(),
              SizedBox(height: 20),
              buildPermissionsSection(),
              SizedBox(height: 24),
              if (editMode)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FlipperButton(
                          width: double.infinity,
                          height: 52,
                          borderRadius: BorderRadius.circular(12),
                          color: _kUserMgmtAccent,
                          textColor: Colors.white,
                          isLoading: isAddingUser,
                          onPressed: isAddingUser
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    setState(() => isAddingUser = true);
                                    try {
                                      await addUser(
                                        model,
                                        context,
                                        editMode: editMode,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        userType: selectedUserType,
                                        userId: editMode && editedTenant != null
                                            ? editedTenant?.userId
                                            : null,
                                      );
                                      resetForm();
                                    } catch (e) {
                                      // handled in addUser
                                    } finally {
                                      setState(() => isAddingUser = false);
                                    }
                                  }
                                },
                          text: "Update User",
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FlipperButton(
                          width: double.infinity,
                          height: 52,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: isAddingUser ? null : () => resetForm(),
                          text: 'Cancel',
                          textColor: _kUserMgmtAccent,
                          color: const Color(0xFFF3F4F6),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FlipperButton(
                    width: double.infinity,
                    height: 52,
                    borderRadius: BorderRadius.circular(12),
                    color: _kUserMgmtAccent,
                    textColor: Colors.white,
                    isLoading: isAddingUser,
                    onPressed: isAddingUser
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              setState(() => isAddingUser = true);
                              try {
                                await addUser(
                                  model,
                                  context,
                                  editMode: editMode,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  userType: selectedUserType,
                                  userId: null,
                                );
                                resetForm();
                              } catch (e) {
                                // handled in addUser
                              } finally {
                                setState(() => isAddingUser = false);
                              }
                            }
                          },
                    text: "+ Add User",
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
