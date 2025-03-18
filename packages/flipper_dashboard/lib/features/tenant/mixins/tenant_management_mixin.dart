import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

import 'tenant_form_mixin.dart';
import 'tenant_operations_mixin.dart';
import 'tenant_permissions_mixin.dart';
import 'tenant_ui_mixin.dart';

mixin TenantManagementMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
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

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    setState(() {
      selectedUserType = 'Agent';
      tenantAllowedFeatures.clear();
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
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
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
        prefixIcon:
            Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Future<void> addUser(FlipperBaseModel model, BuildContext context,
      {required bool editMode,
      required String name,
      required String phone,
      required String userType,
      required int? userId}) async {
    return TenantOperationsMixin.addUserStatic(
      model,
      context,
      editMode: editMode,
      name: name,
      phone: phone,
      userType: userType,
      userId: userId,
      ref: ref,
    );
  }

  void updateTenant({Tenant? tenant, String? name, required String type}) {
    TenantOperationsMixin.updateTenantStatic(
      tenant: tenant,
      name: name,
      type: type,
    );
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
    return TenantPermissionsMixin.savePermissionsStatic(
      newTenant,
      business,
      branch,
      selectedUserType,
      tenantAllowedFeatures,
      activeFeatures,
      userId,
    );
  }

  void fillFormWithTenantData(Tenant tenant, List<Access> tenantAccesses) {
    TenantPermissionsMixin.fillFormWithTenantDataStatic(
      tenant,
      tenantAccesses,
      setState,
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
          flex: 2,
          child: buildTenantsList(model),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: buildAddTenantForm(model, context),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
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
              buildUserTypeDropdown(),
              SizedBox(height: 16),
              buildBranchDropdown(),
              SizedBox(height: 20),
              buildPermissionsSection(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isAddingUser
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isAddingUser = true);
                          try {
                            await addUser(
                              model,
                              context,
                              editMode: editMode,
                              name: nameController.text,
                              phone: phoneController.text,
                              userType: selectedUserType,
                              userId: userId,
                            );
                            resetForm();
                          } finally {
                            setState(() => isAddingUser = false);
                          }
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    isAddingUser
                        ? "Processing..."
                        : editMode
                            ? "Update User"
                            : "Add User",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
