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

      // Get all businesses for this user
      final allBusinesses = await userRepository.getBusinessesForUser(
        widget.userProfile.id,
      );

      // Update all businesses to inactive first
      for (final biz in allBusinesses) {
        final updatedBusiness = Business(
          id: biz.id,
          name: biz.name,
          country: biz.country,
          currency: biz.currency,
          latitude: biz.latitude,
          longitude: biz.longitude,
          active: false, // Set to inactive
          userId: biz.userId,
          phoneNumber: biz.phoneNumber,
          lastSeen: biz.lastSeen,
          backUpEnabled: biz.backUpEnabled,
          fullName: biz.fullName,
          tinNumber: biz.tinNumber,
          taxEnabled: biz.taxEnabled,
          businessTypeId: biz.businessTypeId,
          serverId: biz.serverId,
          isDefault: false, // Set to not default
          lastSubscriptionPaymentSucceeded:
              biz.lastSubscriptionPaymentSucceeded,
        );
        await userRepository.updateBusiness(updatedBusiness);
      }

      // Update the selected business to active and default
      final selectedBusiness = Business(
        id: business.id,
        name: business.name,
        country: business.country,
        currency: business.currency,
        latitude: business.latitude,
        longitude: business.longitude,
        active: true, // Set to active
        userId: business.userId,
        phoneNumber: business.phoneNumber,
        lastSeen: business.lastSeen,
        backUpEnabled: business.backUpEnabled,
        fullName: business.fullName,
        tinNumber: business.tinNumber,
        taxEnabled: business.taxEnabled,
        businessTypeId: business.businessTypeId,
        serverId: business.serverId,
        isDefault: true, // Set to default
        lastSubscriptionPaymentSucceeded:
            business.lastSubscriptionPaymentSucceeded,
      );
      await userRepository.updateBusiness(selectedBusiness);

      // After successful update of the user profile
      if (mounted) {
        // Load branches for the selected business
        final userRepository = ref.read(userRepositoryProvider);
        final branches = await userRepository.getBranchesForBusiness(
          business.serverId.toString(),
        );
        _businessBranches = branches;

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
    setState(() {
      _loadingItemId = branch.id;
      _isLoading = true;
    });

    // Set the selected branch in the provider
    ref.read(selectedBranchProvider.notifier).state = branch;

    try {
      // Get the user repository
      final userRepository = ref.read(userRepositoryProvider);

      // Get all branches for the selected business
      final selectedBusiness = ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) {
        throw Exception("No business selected");
      }

      final allBranches = await userRepository.getBranchesForBusiness(
        selectedBusiness.id,
      );

      // Update all branches to inactive first
      for (final br in allBranches) {
        final updatedBranch = Branch(
          id: br.id,
          description: br.description,
          name: br.name,
          longitude: br.longitude,
          latitude: br.latitude,
          businessId: br.businessId,
          serverId: br.serverId,
        );
        await userRepository.updateBranch(updatedBranch);
      }

      // Update the selected branch to active and default
      final selectedBranch = Branch(
        id: branch.id,
        description: branch.description,
        name: branch.name,
        longitude: branch.longitude,
        latitude: branch.latitude,
        businessId: branch.businessId,
        serverId: branch.serverId,
      );
      await userRepository.updateBranch(selectedBranch);

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
