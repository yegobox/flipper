import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_branch_selector.g.dart';

// Temporary enum for routes until the actual app_router is integrated
enum AppRoute { dashboard, login, businessSelection }

extension AppRouteExtension on AppRoute {
  String get name {
    switch (this) {
      case AppRoute.dashboard:
        return 'dashboard';
      case AppRoute.login:
        return 'login';
      case AppRoute.businessSelection:
        return 'businessSelection';
    }
  }
}

/// Provider for the selected business
@riverpod
class SelectedBusiness extends _$SelectedBusiness {
  @override
  Business? build() => null;

  void set(Business? business) => state = business;
}

/// Provider for the selected branch
@riverpod
class SelectedBranch extends _$SelectedBranch {
  @override
  Branch? build() => null;

  void set(Branch? branch) => state = branch;
}

// Generated providers:
// selectedBusinessProvider
// selectedBranchProvider
// No need for manual aliases if names match.

/// Enum to track the current selection step
enum SelectionStep { business, branch }

class BusinessBranchSelector extends ConsumerStatefulWidget {
  final UserProfile userProfile;

  const BusinessBranchSelector({super.key, required this.userProfile});

  @override
  ConsumerState<BusinessBranchSelector> createState() =>
      _BusinessBranchSelectorState();
}

class _BusinessBranchSelectorState
    extends ConsumerState<BusinessBranchSelector> {
  SelectionStep _currentStep = SelectionStep.business;
  bool _isLoading = false;
  String? _loadingItemId;
  List<Branch> _businessBranches = [];

  @override
  Widget build(BuildContext context) {
    // Since we know there's always only one tenant, get it directly
    final tenant = widget.userProfile.tenants.isNotEmpty
        ? widget.userProfile.tenants.first
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: !_isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentStep == SelectionStep.business
                          ? 'Choose a Business'
                          : 'Choose a Branch',
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _currentStep == SelectionStep.business
                          ? 'Select the business you want to access'
                          : 'Select the branch you want to access',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32.0),
                    Expanded(
                      child: _currentStep == SelectionStep.business
                          ? _buildBusinessList(tenant: tenant)
                          : _buildBranchList(),
                    ),
                  ],
                )
              : Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 3,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBusinessList({required Tenant? tenant}) {
    if (tenant == null || tenant.businesses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No businesses available'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _logout, child: const Text('Logout')),
          ],
        ),
      );
    }

    final selectedBusiness = ref.watch(selectedBusinessProvider);

    return ListView.separated(
      itemCount: tenant.businesses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final business = tenant.businesses[index];
        return _buildSelectionTile(
          title: business.name,
          subtitle: business.fullName,
          isSelected: business.id == selectedBusiness?.id,
          onTap: () => _handleBusinessSelection(tenant, business),
          icon: Icons.business,
          isLoading: _loadingItemId == business.id,
        );
      },
    );
  }

  Widget _buildBranchList() {
    if (_businessBranches.isEmpty) {
      return const Center(child: Text('No branches available'));
    }

    final selectedBranch = ref.watch(selectedBranchProvider);

    return ListView.separated(
      itemCount: _businessBranches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final branch = _businessBranches[index];
        return _buildSelectionTile(
          title: branch.name,
          subtitle: branch.description,
          isSelected: branch.id == selectedBranch?.id,
          onTap: () => _handleBranchSelection(branch),
          icon: Icons.store,
          isLoading: _loadingItemId == branch.id,
        );
      },
    );
  }

  Widget _buildSelectionTile({
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      icon,
                      color: isSelected ? Colors.blue : Colors.grey[600],
                    ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: isSelected
                              ? Colors.blue.shade700
                              : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isSelected ? Colors.blue : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBusinessSelection(Tenant tenant, Business business) async {
    setState(() {
      _loadingItemId = business.id;
      _isLoading = true;
    });

    // Set the selected business in the provider
    ref.read(selectedBusinessProvider.notifier).set(business);

    try {
      // Load branches for the selected business from tenant data (already in memory)
      _businessBranches = tenant.branches
          .where((branch) => branch.businessId == business.id)
          .toList();

      if (mounted) {
        setState(() {
          _loadingItemId = null;
          _isLoading = false;

          // Check if the business has branches
          if (_businessBranches.length == 1) {
            // If there's only one branch, select it automatically
            _handleBranchSelection(_businessBranches.first);
          } else {
            // Otherwise, move to branch selection step
            _currentStep = SelectionStep.branch;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not set business. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _loadingItemId = null;
          _isLoading = false;
        });
      }
    }
  }

  void _handleBranchSelection(Branch branch) async {
    // Set the selected branch in the provider
    ref.read(selectedBranchProvider.notifier).set(branch);

    // Complete the flow and navigate to the dashboard
    _navigateToDashboard();
  }

  // Method removed as it's no longer needed

  void _navigateToDashboard() {
    // Navigate to the dashboard
    context.goNamed(AppRoute.dashboard.name);
  }

  void _logout() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      if (mounted) {
        context.goNamed(AppRoute.login.name);
      }
    } catch (e) {
      // If signOut fails, still navigate to login
      if (mounted) {
        context.goNamed(AppRoute.login.name);
      }
    }
  }
}
