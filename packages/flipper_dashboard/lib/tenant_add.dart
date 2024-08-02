import 'dart:developer';
import 'package:flipper_models/helperModels/random.dart';
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
import 'package:realm/realm.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:email_validator_flutter/email_validator_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'customappbar.dart';

class TenantAdd extends StatefulHookConsumerWidget {
  const TenantAdd({Key? key}) : super(key: key);

  @override
  TenantAddState createState() => TenantAddState();
}

class TenantAddState extends ConsumerState<TenantAdd>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _routerService = locator<RouterService>();
  bool isAddingUser = false;
  String selectedUserType = 'Agent';
  Map<String, String> permissions = {};

  Map<String, bool> activeFeatures = {};
  Map<String, String> tenantPermissions = {};

  @override
  void initState() {
    super.initState();
    for (var feature in features) {
      activeFeatures[feature] =
          false; // or true, depending on your default state
    }
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlipperBaseModel>.reactive(
      onViewModelReady: (model) async => await model.loadTenants(),
      viewModelBuilder: () => FlipperBaseModel(),
      builder: (context, model, widget) {
        return Scaffold(
          appBar: CustomAppBar(
            bottomSpacer: 80,
            title: 'Add a user',
            multi: 3,
            onPop: () async => _routerService.pop(),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: constraints.maxWidth > 600
                      ? _buildWideLayout(model, context)
                      : _buildNarrowLayout(model, context),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWideLayout(FlipperBaseModel model, BuildContext context) {
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

  Widget _buildNarrowLayout(FlipperBaseModel model, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAddTenantForm(model, context),
        const SizedBox(height: 20),
        _buildTenantsList(model),
      ],
    );
  }

  Widget _buildBranchDropdown() {
    final branches = ref.watch(branchesProvider); // No more 'when' needed
    final selectedBranch = ref.watch(selectedBranchProvider);

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
        prefixIcon: Icon(Icons.business, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
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
                "Invite a user to your default branch and business",
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
                title: isAddingUser ? "Adding user..." : "Add user",
                busy: isAddingUser,
                borderRadius: 8,
                onTap: isAddingUser ? null : () => _addUser(model, context),
              ),
            ],
          ),
        ),
      ),
    );
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
      items: <String>['Agent', 'Cashier', 'Admin']
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
              value: permissions[feature] ?? 'No Access',
              onChanged: (String? newValue) {
                setState(() {
                  permissions[feature] = newValue!;
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
                activeFeatures[feature] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  String? _validatePhoneOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a phone number or email address";
    }

    // Check if the value is a valid email
    if (EmailValidatorFlutter().validateEmail(value)) {
      return null;
    }

    // Check if the value is a valid phone number with country code
    if (!value.startsWith("+")) {
      return "Phone number should contain country code with + sign";
    }

    final phone = PhoneNumber.parse(value);
    if (!phone.isValid(type: PhoneNumberType.mobile)) {
      return "Invalid Phone";
    }

    final phoneExp = RegExp(
        r'^\+\d{1,3}\d{7,15}$'); // Updated regex to support general country codes
    if (!phoneExp.hasMatch(value)) {
      return "Invalid phone number";
    }

    return null;
  }

  Future<void> _addUser(FlipperBaseModel model, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isAddingUser = true);
      try {
        Business? business = await ProxyService.local.defaultBusiness();
        Branch? branch = await ProxyService.local.defaultBranch();

        // Save tenant
        Tenant newTenant = await ProxyService.local.saveTenant(
          _phoneController.text,
          _nameController.text,
          branch: branch!,
          business: business!,
          userType: selectedUserType,
        );

        // Save access permissions
        tenantPermissions.forEach((featureName, accessLevel) {
          final access = Access(
            ObjectId(),
            id: randomNumber(),
            branchId: branch.serverId!,
            businessId: business.serverId,
            createdAt: DateTime.now(),
            userType: selectedUserType,
            accessLevel: accessLevel.toLowerCase(),
            status: activeFeatures[featureName] != null
                ? activeFeatures[featureName]!
                    ? 'active'
                    : 'inactive'
                : 'inactive',
            userId: newTenant.userId,
            featureName: featureName,
          );
          ProxyService.realm.realm!.write(() {
            ProxyService.realm.realm!.add<Access>(access);
          });
        });

        await model.loadTenants();

        _resetForm();
      } catch (e, s) {
        // ... existing error handling ...
      } finally {
        setState(() => isAddingUser = false);
      }
    }
  }

  void _updateTenantPermissions(List<Access> tenantAccesses) {
    setState(() {
      tenantPermissions.clear();
      for (Access access in tenantAccesses) {
        if (access.featureName != null && access.accessLevel != null) {
          tenantPermissions[access.featureName!] = access.accessLevel!;
        }
      }
    });
  }

  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    setState(() {
      selectedUserType = 'Agent';
      permissions.clear();
    });
  }

  void _fillFormWithTenantData(Tenant tenant, List<Access> tenantAccesses) {
    setState(() {
      _nameController.text = tenant.name ?? '';
      _phoneController.text = tenant.phoneNumber ?? '';

      // Reset permissions, activeFeatures, and userType
      permissions.clear();
      activeFeatures.clear();
      String? userType;

      // Fill permissions based on tenantAccesses
      for (var access in tenantAccesses) {
        if (access.featureName != null && access.accessLevel != null) {
          // Ensure the accessLevel is a valid option
          ///TODO: if I fix the bug in the bellow code then In dropdowns of permission
          ///I will have duplicate which I do not know how to handle, the issue in bellow
          ///code is that accessLevels list should apply toLowerCase before we apply .contains
          String validAccessLevel = accessLevels.contains(access.accessLevel)
              ? access.accessLevel!
              : 'No Access';
          permissions[access.featureName!] = validAccessLevel;
          activeFeatures[access.featureName!] = access.status == 'active';

          // Set userType if not already set
          if (userType == null && access.userType != null) {
            userType = access.userType;
          }
        }
      }

      // Ensure selectedUserType is a valid option
      selectedUserType = features.contains(userType) ? userType! : 'Agent';

      // Ensure all features have a valid permission set
      for (String feature in features) {
        if (!permissions.containsKey(feature)) {
          permissions[feature] = 'No Access';
        }
        if (!activeFeatures.containsKey(feature)) {
          activeFeatures[feature] = false;
        }
      }
    });

    // Scroll to the form
    Scrollable.ensureVisible(
      _formKey.currentContext!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTenantCard(Tenant tenant, FlipperBaseModel model) {
    List<Access> tenantAccesses =
        ProxyService.realm.access(userId: tenant.userId!);

    return ExpansionTile(
      onExpansionChanged: (expanded) {
        if (expanded) {
          talker.warning(
              "Permission Assigned: ${tenantAccesses.first.accessLevel}");
          _updateTenantPermissions(tenantAccesses);
          _fillFormWithTenantData(tenant, tenantAccesses);
        }
      },
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          tenant.name!.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(tenant.name!, style: TextStyle(fontWeight: FontWeight.bold)),
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
            onPressed: () => _showDeleteConfirmation(context, tenant, model),
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
              ...tenantAccesses
                  .map((access) => _buildAccessItem(access))
                  .toList(),
            ],
          ),
        ),
      ],
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

  void _deleteTenant(Tenant tenant, FlipperBaseModel model) {
    try {
      model.deleteTenant(tenant);

      showToast(context, 'Tenant deleted successfully');
      model.deleteTenant(tenant);
      ProxyService.realm.delete(id: tenant.id!, endPoint: 'tenant');

      /// also delete related permission & acess
      List<LPermission> permissions =
          ProxyService.realm.permissions(userId: tenant.userId!);
      for (LPermission permission in permissions) {
        ProxyService.realm.delete(id: permission.id!, endPoint: 'permission');
      }
      //
      List<Access> accesses = ProxyService.realm.access(userId: tenant.userId!);
      for (Access access in accesses) {
        ProxyService.realm.delete(id: access.id!, endPoint: 'access');
      }

      model.rebuildUi();
    } catch (e) {
      log(e.toString());
      showToast(context, 'Error deleting tenant');
    }
  }
}
