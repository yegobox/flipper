import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
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
  int? userId;
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
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // More rounded
          borderSide: BorderSide.none, // Remove the default border
        ),
        filled: true,
        fillColor:
            Theme.of(context).colorScheme.surfaceContainerHighest, // Use theme color
        contentPadding: EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // add padding inside input
      ),
    );
  }

  Widget buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedUserType,
      onChanged: (String? newValue) {
        setState(() {
          selectedUserType = newValue!;
        });
      },
      items: <String>['Agent', 'Cashier', 'Admin', 'Driver']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: "Select User Type",
        prefixIcon: Icon(Icons.person_outline,
            color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Future<void> addUser(FlipperBaseModel model, BuildContext context,
      {required bool editMode,
      required String name,
      required String phone,
      required String userType,
      required int? userId}) async {
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
      );
    } catch (error) {
      // Log the error to a logging service
      debugPrint('Error adding/updating user: $error');

      // Optionally, re-throw the error if you want the caller to handle it
      rethrow;
    }
  }

  Future<void> deleteTenant(
      Tenant tenant, FlipperBaseModel model, BuildContext context) async {
    return TenantOperationsMixin.deleteTenantStatic(tenant, model, context);
  }

  void showDeleteConfirmation(
      BuildContext context, Tenant tenant, FlipperBaseModel model) {
    TenantOperationsMixin.showDeleteConfirmationStatic(
        context, tenant, model, deleteTenant);
  }

  Future<void> savePermissions(
      Tenant? newTenant, Business? business, Branch? branch) async {
    return TenantOperationsMixin.savePermissionsStatic(
      newTenant,
      business,
      branch,
      selectedUserType,
      tenantAllowedFeatures,
      activeFeatures,
      userId,
      phoneNumber: phoneController.text,
    );
  }

  void fillFormWithTenantData(Tenant tenant, List<Access> tenantAccesses) {
    TenantPermissionsMixin.fillFormWithTenantDataStatic(
      tenant,
      tenantAccesses,
      (fn) => setState(() {
        editMode = true;
        editedTenant = tenant;
        selectedUserType = tenant.type;
        fn();
      }),
      tenantAllowedFeatures,
      activeFeatures,
      selectedUserType,
      nameController,
      phoneController,
      formKey,
    );
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
        Expanded(
          flex: 3,
          child: buildAddTenantForm(model, context),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: buildTenantsList(model),
        ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                editMode ? "Edit User" : "Add New User",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary), // Use theme
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
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
              buildBranchDropdown(),
              SizedBox(height: 20),
              buildPermissionsSection(),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Customize button style
                  padding: const EdgeInsets.all(16.0),
                  textStyle: TextStyle(fontSize: 16),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary, // Use primary color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isAddingUser
                    ? null // Disable when processing
                    : () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save(); // trigger onSaved
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
                child: isAddingUser
                    ? SizedBox(
                        // CircularProgressIndicator with size constraint
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context)
                                  .colorScheme
                                  .onPrimary), // Use correct color
                        ),
                      )
                    : Text(editMode ? "Update User" : "Add User"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
