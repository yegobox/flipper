import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_web/features/business_selection/login_choices_ui.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_branch_selector.g.dart';

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

@riverpod
class SelectedBusiness extends _$SelectedBusiness {
  @override
  Business? build() => null;

  void set(Business? business) => state = business;
}

@riverpod
class SelectedBranch extends _$SelectedBranch {
  @override
  Branch? build() => null;

  void set(Branch? branch) => state = branch;
}

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
  bool _isSigningOut = false;
  String? _loadingItemId;
  String? _selectedBranchId;
  String? _selectedBusinessName;
  List<Branch> _businessBranches = [];

  List<Business> get _businesses {
    final tenant = widget.userProfile.tenants.isNotEmpty
        ? widget.userProfile.tenants.first
        : null;
    return tenant?.businesses ?? [];
  }

  int _branchCountFor(Business business) {
    if (widget.userProfile.tenants.isEmpty) return 0;
    final tenant = widget.userProfile.tenants.first;
    return tenant.branches.where((b) => b.businessId == business.id).length;
  }

  @override
  Widget build(BuildContext context) {
    final businesses = _businesses;
    final userName = displayUserName(widget.userProfile, businesses);
    final userContact = displayUserContact(widget.userProfile, businesses);
    final userInitial = loginChoiceUserInitial(userName);

    return Scaffold(
      backgroundColor: LoginChoicesTokens.app,
      body: LoginChoicesBackground(
        child: SafeArea(
          child: LoginChoicesDesktopScaffold(
            userInitial: userInitial,
            userName: userName,
            userContact: userContact,
            isSigningOut: _isSigningOut,
            onSignOut: _logout,
            child: _isLoading && _loadingItemId == null
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 3,
                        backgroundColor: Color(0xFFE0E0E0),
                      ),
                    ),
                  )
                : _currentStep == SelectionStep.business
                ? _buildBusinessSelection(businesses)
                : _buildBranchSelection(),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessSelection(List<Business> businesses) {
    if (businesses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No businesses available',
              style: TextStyle(color: LoginChoicesTokens.ink2),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _isSigningOut ? null : _logout,
              child: const Text('Sign out'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose a business',
          style: TextStyle(
            color: LoginChoicesTokens.ink1,
            fontWeight: FontWeight.w700,
            height: 1.05,
            fontSize: 27,
            letterSpacing: -0.68,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Select the business you want to manage.',
          style: TextStyle(
            color: LoginChoicesTokens.ink2,
            height: 1.35,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (var i = 0; i < businesses.length; i++) ...[
                BusinessChoiceTile(
                  name: businesses[i].name,
                  subtitle: businessChoiceSubtitle(
                    businesses[i],
                    _branchCountFor(businesses[i]),
                    widget.userProfile.id,
                  ),
                  iconTone: iconToneForIndex(i),
                  isLoading: _loadingItemId == businesses[i].id,
                  onTap: () => _handleBusinessSelection(businesses[i]),
                ),
                if (i < businesses.length - 1)
                  const SizedBox(height: LoginChoicesTokens.cardGap),
              ],
              const SizedBox(height: LoginChoicesTokens.cardGap),
              AddBusinessTile(onTap: () {}),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  'Not seeing your business? Ask the owner to invite you.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: LoginChoicesTokens.ink3,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSelection() {
    final selectedBranchId =
        _selectedBranchId ??
        (_businessBranches.isNotEmpty ? _businessBranches.first.id : null);
    Branch? selectedBranch;
    for (final branch in _businessBranches) {
      if (branch.id == selectedBranchId) {
        selectedBranch = branch;
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BranchSelectionTopRow(
          businessName: _selectedBusinessName ?? 'Business',
          onBack: () {
            setState(() {
              _currentStep = SelectionStep.business;
              _loadingItemId = null;
              _selectedBranchId = null;
              _businessBranches = [];
            });
          },
        ),
        const SizedBox(height: 28),
        const Text(
          'Choose a branch',
          style: TextStyle(
            color: LoginChoicesTokens.ink1,
            fontWeight: FontWeight.w700,
            height: 1.05,
            fontSize: 27,
            letterSpacing: -0.68,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Select the branch you want to access',
          style: TextStyle(
            color: LoginChoicesTokens.ink2,
            height: 1.35,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: _businessBranches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final branch = _businessBranches[index];
              final isSelected =
                  selectedBranchId == branch.id ||
                  (selectedBranchId == null && index == 0);
              return BranchChoiceTile(
                name: branch.name,
                subtitle: branch.description,
                isDefault: branch.isDefault,
                isSelected: isSelected,
                isLoading: _loadingItemId == branch.id,
                onTap: () {
                  setState(() => _selectedBranchId = branch.id);
                },
              );
            },
          ),
        ),
        FlipperGradientButton(
          text: 'Continue to ${selectedBranch?.name ?? 'branch'}',
          icon: Icons.arrow_outward_rounded,
          isLoading: _isLoading,
          onPressed: selectedBranch == null
              ? null
              : () {
                  final branch = selectedBranch;
                  if (branch != null) _handleBranchSelection(branch);
                },
        ),
      ],
    );
  }

  Future<void> _handleBusinessSelection(Business business) async {
    setState(() {
      _loadingItemId = business.id;
      _selectedBranchId = null;
    });

    ref.read(selectedBusinessProvider.notifier).set(business);

    try {
      final tenant = widget.userProfile.tenants.first;
      _businessBranches = tenant.branches
          .where((branch) => branch.businessId == business.id)
          .toList();

      if (!mounted) return;

      if (_businessBranches.length == 1) {
        await _handleBranchSelection(_businessBranches.first);
      } else {
        setState(() {
          _selectedBusinessName = business.name;
          _currentStep = SelectionStep.branch;
          _loadingItemId = null;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not set business. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _loadingItemId = null);
      }
    }
  }

  Future<void> _handleBranchSelection(Branch branch) async {
    setState(() {
      _loadingItemId = branch.id;
      _isLoading = true;
    });

    ref.read(selectedBranchProvider.notifier).set(branch);

    if (mounted) {
      context.goNamed(AppRoute.dashboard.name);
    }
  }

  Future<void> _logout() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      if (mounted) {
        context.goNamed(AppRoute.login.name);
      }
    } catch (_) {
      if (mounted) {
        context.goNamed(AppRoute.login.name);
      }
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }
}
