import 'package:flipper_web/models/mutable_user_profile.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
final selectedBusinessProvider = StateProvider<Business?>((ref) => null);

/// Provider for the selected branch
final selectedBranchProvider = StateProvider<Branch?>((ref) => null);

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
                          : _buildBranchList(branches: tenant?.branches ?? []),
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
    if (tenant == null) {
      return const Center(child: Text('No businesses available'));
    }

    if (tenant.businesses.isEmpty) {
      return const Center(child: Text('No businesses available'));
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

  Widget _buildBranchList({required List<Branch> branches}) {
    if (branches.isEmpty) {
      return const Center(child: Text('No branches available'));
    }

    final selectedBranch = ref.watch(selectedBranchProvider);

    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final branch = branches[index];
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
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
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
    ref.read(selectedBusinessProvider.notifier).state = business;

    try {
      // Get the user repository from the provider
      final userRepository = ref.read(userRepositoryProvider);

      // Get the current user profile and convert to mutable version
      final userProfile = widget.userProfile;
      final mutableProfile = MutableUserProfile.fromUserProfile(userProfile);

      // Update all businesses to inactive first
      for (var t in mutableProfile.tenants) {
        for (var biz in t.businesses) {
          biz.active = false;
          biz.isDefault = false;
        }
      }

      // Find the selected tenant and mark the selected business as default
      for (var t in mutableProfile.tenants) {
        if (t.id == tenant.id) {
          // Mark this tenant as default
          t.isDefault = true;

          // Find and update the selected business
          for (var biz in t.businesses) {
            if (biz.id == business.id) {
              biz.active = true;
              biz.isDefault = true;
              break;
            }
          }
          break;
        }
      }

      // Convert back to immutable model and save to Ditto
      final updatedProfile = mutableProfile.toUserProfile();

      // Since the userRepository no longer requires the token parameter for
      // updateUserProfile (it's now handled internally), we can just pass the profile
      await userRepository.updateUserProfile(
        updatedProfile,
        '', // Empty token since it's not used anymore
      );

      // After successful update of the user profile
      if (mounted) {
        setState(() {
          _loadingItemId = null;
          _isLoading = false;

          // Check if the tenant has branches
          if (tenant.branches.length == 1) {
            // If there's only one branch, select it automatically
            _handleBranchSelection(tenant.branches.first);
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
    setState(() {
      _loadingItemId = branch.id;
      _isLoading = true;
    });

    // Set the selected branch in the provider
    ref.read(selectedBranchProvider.notifier).state = branch;

    try {
      // Get the user repository
      final userRepository = ref.read(userRepositoryProvider);

      // Since we know there's always only one tenant, get it directly
      final tenant = widget.userProfile.tenants.isNotEmpty
          ? widget.userProfile.tenants.first
          : null;

      if (tenant == null) {
        throw Exception("No tenant available");
      }

      // Get the current user profile and convert to mutable version
      final userProfile = widget.userProfile;
      final mutableProfile = MutableUserProfile.fromUserProfile(userProfile);

      // Find the tenant in mutable profile (there should be only one)
      final mutableTenant = mutableProfile.tenants.first;

      // Set all branches to inactive
      for (var b in mutableTenant.branches) {
        b.active = false;
        b.isDefault = false;
      }

      // Find and update the selected branch
      for (var b in mutableTenant.branches) {
        if (b.id == branch.id) {
          b.active = true;
          b.isDefault = true;
          break;
        }
      }

      // Convert back to immutable model and save to Ditto
      final updatedProfile = mutableProfile.toUserProfile();

      // Save the updated user profile to Ditto
      await userRepository.updateUserProfile(
        updatedProfile,
        '', // Empty token since it's not used anymore
      );

      // Complete the flow and navigate to the dashboard
      _navigateToDashboard();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not set branch. Please try again.'),
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

  // Method removed as it's no longer needed

  void _navigateToDashboard() {
    // Navigate to the dashboard
    context.goNamed(AppRoute.dashboard.name);
  }
}
