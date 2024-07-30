import 'package:flipper_dashboard/tenant_add.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AdminControl extends StatelessWidget {
  const AdminControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => locator<RouterService>().back(),
          tooltip: 'Back',
        ),
        title: Text(
          'Manage Your Account and Preferences',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
        ),
        // actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SettingsSection(
                      title: 'Account',
                      children: [
                        const SizedBox(height: 16),
                        SettingsCard(
                          title: 'User Management',
                          subtitle: 'Manage users and permissions',
                          icon: Icons.people,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TenantAdd();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 24),
                  // Expanded(
                  //   child: SettingsSection(
                  //     title: 'Financial',
                  //     children: [
                  //       SettingsCard(
                  //         title: 'Tax Control',
                  //         subtitle: 'Manage tax settings and reports',
                  //         icon: Icons.attach_money,
                  //         onTap: () {},
                  //       ),
                  //       const SizedBox(height: 16),
                  //       SettingsCard(
                  //         title: 'Payment Methods',
                  //         subtitle: 'Manage your payment options',
                  //         icon: Icons.credit_card,
                  //         onTap: () {
                  //           // Navigate to Payment Methods page
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              // const SizedBox(height: 24),
              // SettingsSection(
              //   title: 'Preferences',
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           child: SwitchSettingsCard(
              //             title: 'Dark Mode',
              //             subtitle: 'Toggle dark mode on/off',
              //             icon: Icons.dark_mode,
              //             value: false,
              //             onChanged: (value) {
              //               // Implement dark mode toggle
              //             },
              //           ),
              //         ),
              //         const SizedBox(width: 16),
              //         Expanded(
              //           child: SwitchSettingsCard(
              //             title: 'Notifications',
              //             subtitle: 'Enable or disable notifications',
              //             icon: Icons.notifications,
              //             value: true,
              //             onChanged: (value) {
              //               // Implement notifications toggle
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchSettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchSettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
