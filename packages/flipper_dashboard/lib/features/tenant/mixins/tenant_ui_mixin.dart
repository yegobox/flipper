import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TenantUIMixin {
  static Widget buildTenantsListStatic(
    BuildContext context,
    FlipperBaseModel model,
    Widget Function(Tenant, FlipperBaseModel) buildTenantCard,
  ) {
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
                  buildTenantCard(model.tenants[index], model),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTenantCardStatic(
    BuildContext context,
    Tenant tenant,
    FlipperBaseModel model,
    bool editMode,
    int? userId,
    void Function(void Function()) setState,
    void Function(List<Access>) updateTenantPermissions,
    void Function(Tenant, List<Access>) fillFormWithTenantData,
    void Function(BuildContext, Tenant, FlipperBaseModel)
        showDeleteConfirmation,
  ) {
    return FutureBuilder<List<Access>>(
      future: Future.value(ProxyService.strategy
          .access(userId: tenant.userId!, fetchRemote: false)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingTenantTileStatic(context, tenant);
        } else if (snapshot.hasError) {
          return buildErrorTenantTileStatic(context, tenant);
        } else {
          return buildExpandableTenantTileStatic(
            context,
            tenant,
            model,
            editMode,
            userId,
            setState,
            snapshot.data ?? [],
            updateTenantPermissions,
            fillFormWithTenantData,
            showDeleteConfirmation,
          );
        }
      },
    );
  }

  static Widget buildLoadingTenantTileStatic(
      BuildContext context, Tenant tenant) {
    return ListTile(
      leading: buildTenantAvatarStatic(context, tenant),
      title: Text(tenant.name!, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Loading permissions..."),
    );
  }

  static Widget buildErrorTenantTileStatic(
      BuildContext context, Tenant tenant) {
    return ListTile(
      leading: buildTenantAvatarStatic(context, tenant),
      title: Text(tenant.name!, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Error loading permissions"),
    );
  }

  static Widget buildExpandableTenantTileStatic(
    BuildContext context,
    Tenant tenant,
    FlipperBaseModel model,
    bool editMode,
    int? userId,
    void Function(void Function()) setState,
    List<Access> tenantAccesses,
    void Function(List<Access>) updateTenantPermissions,
    void Function(Tenant, List<Access>) fillFormWithTenantData,
    void Function(BuildContext, Tenant, FlipperBaseModel)
        showDeleteConfirmation,
  ) {
    final bool isAdmin = tenantAccesses
        .any((access) => (access.accessLevel?.toLowerCase() == 'admin'));

    return ExpansionTile(
      onExpansionChanged: (expanded) {
        if (expanded) {
          setState(() {
            editMode = true;
            userId = tenant.userId!;
          });
          updateTenantPermissions(tenantAccesses);
          fillFormWithTenantData(tenant, tenantAccesses);
        } else {
          setState(() {
            editMode = false;
          });
        }
      },
      leading: buildTenantAvatarStatic(context, tenant),
      title: Text(tenant.name!, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(tenant.phoneNumber ?? "No phone number"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildNfcButtonStatic(context, tenant),
          if (!isAdmin)
            buildDeleteButtonStatic(
                context, tenant, model, showDeleteConfirmation),
        ],
      ),
      children: [
        buildPermissionsViewStatic(tenantAccesses),
      ],
    );
  }

  static Widget buildTenantAvatarStatic(BuildContext context, Tenant tenant) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        tenant.name!.substring(0, 1).toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static Widget buildNfcButtonStatic(BuildContext context, Tenant tenant) {
    return IconButton(
      icon: Icon(
        tenant.nfcEnabled == true ? Icons.nfc : Icons.nfc_outlined,
        color: tenant.nfcEnabled == true
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
      onPressed: () => null,
    );
  }

  static Widget buildDeleteButtonStatic(
    BuildContext context,
    Tenant tenant,
    FlipperBaseModel model,
    void Function(BuildContext, Tenant, FlipperBaseModel)
        showDeleteConfirmation,
  ) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () => showDeleteConfirmation(context, tenant, model),
    );
  }

  static Widget buildPermissionsViewStatic(List<Access> tenantAccesses) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Permissions:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (tenantAccesses.isEmpty) Text("No permissions assigned."),
          ...tenantAccesses
              .map((access) => buildAccessItemStatic(access))
              .toList(),
        ],
      ),
    );
  }

  static Widget buildAccessItemStatic(Access access) {
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
            backgroundColor: getAccessLevelColorStatic(access.accessLevel),
          ),
        ],
      ),
    );
  }

  static Color getAccessLevelColorStatic(String? accessLevel) {
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

  static Widget buildBranchDropdownStatic(BuildContext context, WidgetRef ref) {
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
}
