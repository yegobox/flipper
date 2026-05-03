import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

import 'tenant_form_mixin.dart';
import 'tenant_operations_mixin.dart';
import 'tenant_permissions_mixin.dart';
import 'tenant_ui_mixin.dart';

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
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedUserType,
      onChanged: (String? newValue) {
        setState(() {
          selectedUserType = newValue!;
        });
      },
      items: <String>['Agent', 'Cashier', 'Admin', 'Driver']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)));
          })
          .toList(),
      decoration: InputDecoration(
        labelText: "Select User Type",
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.person_outline, color: Colors.blueAccent),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
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

  void updateTenantPermissions(List<Access> tenantAccesses) {
    TenantPermissionsMixin.updateTenantPermissionsStatic(
      tenantAccesses,
      setState,
      tenantAllowedFeatures,
    );
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
    );
  }

  Widget buildTenantCard(Tenant tenant, FlipperBaseModel model) {
    return TenantUIMixin.buildTenantCardStatic(
      context,
      tenant,
      model,
      editMode,
      userId,
      setState,
      updateTenantPermissions,
      fillFormWithTenantData,
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
        SizedBox(width: 20),
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
            color: Colors.black.withOpacity(0.04),
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              buildTextFormField(
                controller: nameController,
                labelText: "Name",
                icon: Icons.person,
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
                labelText: "Phone Number or Email",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: TenantFormMixin.validatePhoneOrEmailStatic,
              ),
              SizedBox(height: 16),
              // Use the instance dropdown to ensure correct userType wiring
              buildUserTypeDropdown(),
              SizedBox(height: 16),
              if (selectedUserType != 'Agent') buildBranchDropdown(),
              SizedBox(height: 20),
              buildPermissionsSection(),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FlipperButton(
                      color: Colors.blueAccent,
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
                                  // Error is already handled in the `addUser` method
                                } finally {
                                  setState(() => isAddingUser = false);
                                }
                              }
                            },
                      text: editMode ? "Update User" : "Add User",
                    ),
                  ),
                  if (editMode) ...[
                    SizedBox(width: 16),
                    Expanded(
                      child: FlipperButton(
                        onPressed: () => resetForm(),
                        text: 'Cancel',
                        textColor: Colors.blueAccent,
                        color: const Color(0xFFF3F4F6),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
