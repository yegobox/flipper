import 'dart:developer';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:flutter/material.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:email_validator_flutter/email_validator_flutter.dart';

mixin TenantManagementMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final routerService = locator<RouterService>();
  bool isAddingUser = false;
  bool editMode = false;
  String selectedUserType = 'Agent';
  Map<String, bool> activeFeatures = {};
  Map<String, String> tenantAllowedFeatures = {};
  int? userId;

  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    setState(() {
      selectedUserType = 'Agent';
      tenantAllowedFeatures.clear();
    });
  }

  Future<void> _addUser(FlipperBaseModel model, BuildContext context,
      {required bool editMode}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isAddingUser = true);
      try {
        Business? business = await ProxyService.strategy.defaultBusiness();
        Branch? branch = ref.read(selectedBranchProvider) ??
            await ProxyService.strategy.defaultBranch();

        Tenant? newTenant;
        if (!editMode) {
          newTenant = await ProxyService.strategy.saveTenant(
              name: _nameController.text,
              phoneNumber: _phoneController.text,
              branch: branch!,
              business: business!,
              userType: selectedUserType,
              flipperHttpClient: ProxyService.http);
        } else {
          newTenant = await ProxyService.strategy.getTenant(userId: userId!);
        }

        await _savePermissions(newTenant, business, branch);
        _updateTenant(
            tenant: newTenant,
            name: _nameController.text,
            type: selectedUserType);

        await model.loadTenants();
        _resetForm();
      } catch (e, s) {
        talker.error(s);
        rethrow;
      } finally {
        setState(() => isAddingUser = false);
      }
    }
  }

  void _updateTenant({Tenant? tenant, String? name, required String type}) {
    try {
      if (name != null && !name.isEmpty) {
        ProxyService.strategy.updateTenant(
          tenantId: tenant!.id,
          name: name,
          type: type,
          pin: tenant.userId,
        );
      }
    } catch (e) {
      talker.error(e);
    }
  }

  Future<void> _savePermissions(
      Tenant? newTenant, Business? business, Branch? branch) async {
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
          userType: selectedUserType,
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
            userType: selectedUserType);
      }
    });
  }

  String? _validatePhoneOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a phone number or email address";
    }

    if (EmailValidatorFlutter().validateEmail(value)) {
      return null;
    }

    if (!value.startsWith("+")) {
      return "Phone number should contain country code with + sign";
    }

    final phone = PhoneNumber.parse(value);
    if (!phone.isValid(type: PhoneNumberType.mobile)) {
      return "Invalid Phone";
    }

    final phoneExp = RegExp(r'^\+\d{1,3}\d{7,15}$');
    if (!phoneExp.hasMatch(value)) {
      return "Invalid phone number";
    }

    return null;
  }

  void _fillFormWithTenantData(Tenant tenant, List<Access> tenantAccesses) {
    setState(() {
      _nameController.text = tenant.name ?? '';
      _phoneController.text = tenant.phoneNumber ?? '';

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

      selectedUserType = features.contains(userType) ? userType! : 'Agent';

      for (String feature in features) {
        if (!tenantAllowedFeatures.containsKey(feature)) {
          tenantAllowedFeatures[feature] = 'No Access';
        }
        if (!activeFeatures.containsKey(feature)) {
          activeFeatures[feature] = false;
        }
      }
    });

    Scrollable.ensureVisible(
      _formKey.currentContext!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _updateTenantPermissions(List<Access> tenantAccesses) {
    setState(() {
      tenantAllowedFeatures.clear();
      for (Access access in tenantAccesses) {
        if (access.featureName != null && access.accessLevel != null) {
          tenantAllowedFeatures[access.featureName!] = access.accessLevel!;
        }
      }
    });
  }

  Widget _buildTenantsList(FlipperBaseModel model) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Current Users",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: model.tenants.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey),
              itemBuilder: (context, index) =>
                  _buildTenantCard(model.tenants[index], model),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantCard(Tenant tenant, FlipperBaseModel model) {
    return FutureBuilder<List<Access>>(
      future:
          Future.value(ProxyService.strategy.access(userId: tenant.userId!)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the data
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                tenant.name!.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(tenant.name!,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Loading permissions..."),
          );
        } else if (snapshot.hasError) {
          // Handle any errors that occur while fetching data
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                tenant.name!.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(tenant.name!,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Error loading permissions"),
          );
        } else {
          // Display the tenant card when data is successfully fetched
          final List<Access> tenantAccesses = snapshot.data ?? [];
          return ExpansionTile(
            onExpansionChanged: (expanded) {
              if (expanded) {
                setState(() {
                  editMode = true;
                  userId = tenant.userId!;
                });
                talker.warning(
                    "Permission Assigned: ${tenantAccesses.isNotEmpty ? tenantAccesses.first.accessLevel : 'No Access'}");
                _updateTenantPermissions(tenantAccesses);
                _fillFormWithTenantData(tenant, tenantAccesses);
              } else {
                setState(() {
                  editMode = false;
                });
              }
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                tenant.name!.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(tenant.name!,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(tenant.phoneNumber ?? "No phone number"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    tenant.nfcEnabled == true ? Icons.nfc : Icons.nfc_outlined,
                    color: tenant.nfcEnabled == true
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  onPressed: () => _toggleNFC(tenant, model),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _showDeleteConfirmation(context, tenant, model),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Permissions:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    if (tenantAccesses.isEmpty)
                      Text("No permissions assigned."),
                    ...tenantAccesses
                        .map((access) => _buildAccessItem(access))
                        .toList(),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildAccessItem(Access access) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(access.featureName ?? "Unknown Feature"),
          Chip(
            label: Text(
              access.accessLevel?.toUpperCase() ?? "UNKNOWN",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: _getAccessLevelColor(access.accessLevel),
          ),
        ],
      ),
    );
  }

  Color _getAccessLevelColor(String? accessLevel) {
    switch (accessLevel?.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'write':
        return Colors.green;
      case 'read':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _toggleNFC(Tenant tenant, FlipperBaseModel model) async {
    try {
      await AppService().nfc.stopNfc();
    } catch (e) {}
    AppService().nfc.startNFC(
          callback: (nfcData) async {
            nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last;
            showToast(context, 'NFC card added to ${tenant.name}');
            model.loadTenants();
          },
          textData:
              "${tenant.id}:${ProxyService.box.getBusinessId()}:${ProxyService.box.getBranchId()}:${tenant.phoneNumber}",
          write: true,
        );
  }

  void _showDeleteConfirmation(
      BuildContext context, Tenant tenant, FlipperBaseModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Tenant"),
          content: Text("Are you sure you want to delete this tenant?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTenant(tenant, model);
              },
              child: Text("Delete"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTenant(Tenant tenant, FlipperBaseModel model) async {
    try {
      model.deleteTenant(tenant);

      showToast(context, 'Tenant deleted successfully');
      model.deleteTenant(tenant);
      ProxyService.strategy.delete(
          id: tenant.id,
          endPoint: 'tenant',
          flipperHttpClient: ProxyService.http);

      List<LPermission> permissions =
          await ProxyService.strategy.permissions(userId: tenant.userId!);
      for (LPermission permission in permissions) {
        ProxyService.strategy.delete(
            id: permission.id,
            endPoint: 'permission',
            flipperHttpClient: ProxyService.http);
      }

      List<Access> accesses =
          await ProxyService.strategy.access(userId: tenant.userId!);
      for (Access access in accesses) {
        ProxyService.strategy.delete(
            id: access.id,
            endPoint: 'access',
            flipperHttpClient: ProxyService.http);
      }

      model.rebuildUi();
    } catch (e) {
      log(e.toString());
      showToast(context, 'Error deleting tenant');
    }
  }

  Widget _buildTextFormField({
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

  Widget _buildUserTypeDropdown() {
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

  Widget _buildPermissionsSection() {
    return Column(
      children: features.map((feature) {
        return _buildPermissionRow(feature);
      }).toList(),
    );
  }

  Widget _buildPermissionRow(String feature) {
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
                  tenantAllowedFeatures
                      .addEntries(<String, String>{feature: 'write'}.entries);
                }

                activeFeatures[feature] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBranchDropdown() {
    final asyncBranches = ref.watch(branchesProvider((includeSelf: false)));
    final selectedBranch = ref.watch(selectedBranchProvider);

    return asyncBranches.when(
      data: (branches) {
        if (branches.isEmpty) {
          return Text("No branches available");
        }

        return DropdownButtonFormField<Branch>(
          value: selectedBranch ?? branches.first,
          onChanged: (Branch? newValue) {
            ref.read(selectedBranchProvider.notifier).state = newValue;
          },
          items: branches.map<DropdownMenuItem<Branch>>((Branch branch) {
            return DropdownMenuItem<Branch>(
              value: branch,
              child: Text(branch.name ?? 'Unnamed Branch'),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Select Branch",
            prefixIcon:
                Icon(Icons.business, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }

  Widget _buildAddTenantForm(FlipperBaseModel model, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Invite Users",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTextFormField(
                controller: _nameController,
                labelText: "Name of the user",
                icon: Icons.person,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              _buildBranchDropdown(),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                labelText: "Phone number or Email",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _validatePhoneOrEmail,
              ),
              const SizedBox(height: 16),
              _buildUserTypeDropdown(),
              const SizedBox(height: 24),
              const Text(
                "Set Permissions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPermissionsSection(),
              const SizedBox(height: 32),
              BoxButton(
                title: editMode
                    ? "Update"
                    : isAddingUser
                        ? "Adding user..."
                        : "Add user",
                busy: isAddingUser,
                borderRadius: 8,
                onTap: isAddingUser
                    ? null
                    : () => _addUser(model, context, editMode: editMode),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWideLayout(FlipperBaseModel model, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildAddTenantForm(model, context),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: _buildTenantsList(model),
        ),
      ],
    );
  }

  Widget buildNarrowLayout(FlipperBaseModel model, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAddTenantForm(model, context),
        const SizedBox(height: 20),
        _buildTenantsList(model),
      ],
    );
  }
}
