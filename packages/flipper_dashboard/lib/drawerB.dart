import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          _buildBusinessSection(context),
          const Divider(),
          _buildNavigationItems(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return FutureBuilder<Tenant?>(
      future: _getTenantFuture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child:
                Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        final tenant = snapshot.data;
        return DrawerHeader(
          decoration: const BoxDecoration(color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.business,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tenant?.name ?? "My Business",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tenant?.email ?? tenant?.phoneNumber ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessSection(BuildContext context) {
    final userId = ProxyService.box.getUserId();
    if (userId == null) {
      return const ListTile(
        title: Text('No user logged in'),
        leading: Icon(Icons.error_outline),
      );
    }

    return FutureBuilder<List<Business>>(
      future: ProxyService.strategy.businesses(userId: userId),
      builder: (context, businessSnapshot) {
        if (businessSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            title: Text('Loading businesses...'),
          );
        }

        if (businessSnapshot.hasError) {
          return ListTile(
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: const Text('Error loading businesses'),
            subtitle: Text(businessSnapshot.error.toString()),
            onTap: () => _retryLoadingBusinesses(context),
          );
        }

        final List<Business> businesses = businessSnapshot.data ?? [];
        if (businesses.isEmpty) {
          return const ListTile(
            leading: Icon(Icons.business_outlined),
            title: Text('No businesses found'),
          );
        }

        return _buildBusinessesWithBranches(context, businesses);
      },
    );
  }

  Widget _buildBusinessesWithBranches(
      BuildContext context, List<Business> businesses) {
    return Column(
      children: businesses.map((business) {
        return _buildBusinessWithBranches(context, business);
      }).toList(),
    );
  }

  Widget _buildBusinessWithBranches(BuildContext context, Business business) {
    return FutureBuilder<List<Branch>>(
      future: ProxyService.strategy.branches(businessId: business.serverId),
      builder: (context, branchSnapshot) {
        if (branchSnapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(business.name ?? 'Loading...'),
            leading: const Icon(Icons.business),
            trailing: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (branchSnapshot.hasError) {
          return ListTile(
            title: Text(business.name ?? 'Error'),
            leading: const Icon(Icons.business),
            subtitle: Text('Error: ${branchSnapshot.error}'),
            trailing: const Icon(Icons.error_outline, color: Colors.red),
          );
        }

        final List<Branch> branches = branchSnapshot.data ?? [];

        return BusinessTile(
          businessName: business.name ?? 'Unnamed Business',
          branches: branches.isEmpty
              ? ['Main Branch']
              : branches
                  .map((branch) => branch.name ?? 'Unnamed Branch')
                  .toList(),
          onBranchSelected: (branchName) {
            _handleBranchSelection(context, business, branchName);
          },
        );
      },
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () => _navigateTo(context, '/dashboard'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () => _navigateTo(context, '/settings'),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          onTap: () => _navigateTo(context, '/support'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => _handleLogout(context),
        ),
      ],
    );
  }

  // Helper methods
  Future<Tenant?> _getTenantFuture() async {
    final userId = ProxyService.box.getUserId();
    if (userId == null) return null;
    return ProxyService.strategy.getTenant(userId: userId);
  }

  void _retryLoadingBusinesses(BuildContext context) {
    // Force rebuild
    (context as Element).markNeedsBuild();
  }

  void _handleBranchSelection(
      BuildContext context, Business business, String branchName) {
    Navigator.pop(context);
  }

  void _navigateTo(BuildContext context, String route) {
    // TODO: Implement navigation
    // Navigator.pop(context);
    // Navigator.pushNamed(context, route);
  }

  void _handleLogout(BuildContext context) {
    // TODO: Implement logout logic
    Navigator.pop(context);
  }
}

class BusinessTile extends StatefulWidget {
  final String businessName;
  final List<String> branches;
  final Function(String) onBranchSelected;

  const BusinessTile({
    required this.businessName,
    required this.branches,
    required this.onBranchSelected,
    Key? key,
  }) : super(key: key);

  @override
  _BusinessTileState createState() => _BusinessTileState();
}

class _BusinessTileState extends State<BusinessTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.businessName),
      leading: const Icon(Icons.business),
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      initiallyExpanded: _isExpanded,
      children: widget.branches
          .map((branch) => ListTile(
                title: Text(branch),
                leading: const Icon(Icons.store, size: 20),
                contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0),
                onTap: () {
                  widget.onBranchSelected(branch);
                },
              ))
          .toList(),
    );
  }
}
