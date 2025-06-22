import 'package:flipper_dashboard/ReinitializeEbm.dart';
import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import '../controllers/admin_controller.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_section.dart';
import '../widgets/switch_settings_card.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminController(),
      child: const _AdminScreenContent(),
    );
  }
}

class _AdminScreenContent extends StatelessWidget {
  const _AdminScreenContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AdminController>();
    final navigator = locator<RouterService>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navigator.navigateTo(FlipperAppRoute()),
          tooltip: 'Back',
        ),
        title: Text(
          'Management Dashboard',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickActions(context, controller),
                const SizedBox(height: 32),
                _buildMainSections(context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AdminController controller) {
    return SettingsSection(
      title: 'Quick Actions',
      children: [
        Row(
          children: [
            Expanded(
              child: SwitchSettingsCard(
                title: 'POS Default',
                subtitle: 'Set POS as default app',
                icon: Icons.point_of_sale,
                value: controller.isPosDefault,
                onChanged: controller.togglePos,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SwitchSettingsCard(
                title: 'Orders Default',
                subtitle: 'Set Orders as default app',
                icon: Icons.receipt_long,
                value: controller.isOrdersDefault,
                onChanged: controller.toggleOrders,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainSections(BuildContext context, AdminController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildAccountManagement(context),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFinancialControls(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSmsConfig(context, controller),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSystemSettings(context, controller),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountManagement(BuildContext context) {
    return SettingsSection(
      title: 'Account Management',
      children: [
        SettingsCard(
          title: 'User Management',
          subtitle: 'Manage users and permissions',
          icon: Icons.people,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => TenantManagement(),
            );
          },
          color: Colors.indigo,
        ),
        const SizedBox(height: 16),
        SettingsCard(
          title: 'Branch Management',
          subtitle: 'Manage Branch (Locations)',
          icon: Icons.business,
          onTap: () {
            locator<RouterService>().navigateTo(AddBranchRoute());
          },
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildFinancialControls(BuildContext context) {
    return SettingsSection(
      title: 'Financial Controls',
      children: [
        SettingsCard(
          title: 'Tax Settings',
          subtitle: 'Configure tax rules and rates',
          icon: Icons.account_balance,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => TaxSettingsModal(
                branchId: ProxyService.box.getBranchId()!,
              ),
            );
          },
          color: Colors.purple,
        ),
        const SizedBox(height: 16),
        SettingsCard(
          title: 'EBM Settings',
          subtitle: 'Electronic Billing Machine settings',
          icon: Icons.receipt,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ReInitializeEbmDialog(),
            );
          },
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSmsConfig(BuildContext context, AdminController controller) {
    return SettingsSection(
      title: 'SMS Configuration',
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+250783054874',
                    errorText: controller.phoneError,
                  ),
                  onChanged: (value) =>
                      controller.updateSmsConfig(phone: value),
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  title: const Text('Enable SMS Notifications'),
                  value: controller.enableSmsNotification,
                  onChanged: (value) =>
                      controller.updateSmsConfig(enable: value),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemSettings(
      BuildContext context, AdminController controller) {
    return SettingsSection(
      title: 'System Settings',
      children: [
        SwitchSettingsCard(
          title: 'Debug Mode',
          subtitle: 'Enable debug features',
          icon: Icons.bug_report,
          value: controller.enableDebug,
          onChanged: (_) => controller.toggleDebug(),
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        SwitchSettingsCard(
          title: 'Force Update',
          subtitle: 'Force update all data',
          icon: Icons.update,
          value: controller.forceUPSERT,
          onChanged: (_) => controller.toggleForceUPSERT(),
          color: Colors.amber,
        ),
        const SizedBox(height: 16),
        SwitchSettingsCard(
          title: 'Tax Service',
          subtitle: 'Toggle tax service',
          icon: Icons.receipt_long,
          value: controller.stopTaxService,
          onChanged: (_) => controller.toggleTaxService(),
          color: Colors.deepPurple,
        ),
      ],
    );
  }
}
