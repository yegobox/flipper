// ignore_for_file: unused_result

import 'dart:async';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
// Import for payment plan route is already available from app.router.dart
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_models/exceptions.dart'
    show FailedPaymentException, NoPaymentPlanFound;

class LoginChoices extends StatefulHookConsumerWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  _LoginChoicesState createState() => _LoginChoicesState();
}

class _LoginChoicesState extends ConsumerState<LoginChoices>
    with BranchSelectionMixin {
  bool _isSelectingBranch = false;
  Business? _selectedBusiness;
  bool _isLoading = false;
  String? _loadingItemId;

  final _routerService = locator<RouterService>();
  final talker = Talker();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, viewModel, child) {
        final businesses = ref.watch(businessesProvider);
        final branches = ref.watch(
            branchesProvider(businessId: ProxyService.box.getBusinessId()));

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: !_isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSelectingBranch
                              ? 'Choose a Branch'
                              : 'Choose a Business',
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _isSelectingBranch
                              ? 'Select the branch you want to access'
                              : 'Select the business you want to log into',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Expanded(
                          child: _isSelectingBranch
                              ? buildBranchList(
                                  // Use the mixin's method
                                  branches: branches.value!,
                                  loadingItemId: _loadingItemId,
                                  onBranchSelected: (branch, context) =>
                                      _handleBranchSelection(branch, context))
                              : _buildBusinessList(
                                  businesses: businesses.value),
                        ),
                      ],
                    )
                  : Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                          strokeWidth: 3,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusinessList({List<Business>? businesses}) {
    if (businesses == null) return const SizedBox();
    return ListView.separated(
      itemCount: businesses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final business = businesses[index];
        return _buildSelectionTile(
          title: business.name!,
          isSelected: business == _selectedBusiness,
          onTap: () => _handleBusinessSelection(business),
          icon: Icons.business,
          isLoading: _loadingItemId == (business.serverId.toString()),
        );
      },
    );
  }

  Widget _buildSelectionTile({
    required String title,
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
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: .1)
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
                        blurRadius: 8.0)
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
                  : Icon(icon,
                      color: isSelected ? Colors.blue : Colors.grey[600]),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
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

  Future<void> _handleBusinessSelection(Business business) async {
    setState(() {
      _loadingItemId = business.serverId.toString();
    });
    try {
      // Save business ID to local storage
      await ProxyService.box
          .writeInt(key: 'businessId', value: business.serverId);
      await _setDefaultBusiness(business);
      final branches = await ProxyService.strategy.branches(
        businessId: business.serverId,
        active: false,
      );

      if (branches.length == 1) {
        // If there's only one branch, set it as default and complete login
        await _setDefaultBranch(branches.first);
        _completeAuthenticationFlow();
      } else {
        // If multiple branches, show branch selection
        setState(() {
          _selectedBusiness = business;
          _isSelectingBranch = true;
        });
        ref.refresh(branchesProvider(businessId: _selectedBusiness!.serverId));
      }
    } catch (e) {
      talker.error('Error handling business selection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingItemId = null;
        });
      }
    }
  }

  Future<void> _handleBranchSelection(
      Branch branch, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() {
      _loadingItemId = branch.serverId?.toString();
      _isLoading = true;
      _isSelectingBranch = false;
    });

    await ProxyService.box
        .writeBool(key: 'branch_navigation_in_progress', value: true);

    try {
      await _setDefaultBranch(branch);

      // Check for active subscription
      try {
        final startupViewModel = StartupViewModel();
        await startupViewModel.hasActiveSubscription();
      } on FailedPaymentException catch (e) {
        talker.error('Payment failed: ${e.message}');
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
        _routerService.navigateTo(FailedPaymentRoute());
        return;
      } on NoPaymentPlanFound catch (e) {
        talker.error('No payment plan found: $e');
        _routerService.navigateTo(PaymentPlanUIRoute());
        return;
      } catch (e, stackTrace) {
        talker.error('Subscription check failed: $e', stackTrace);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error checking subscription: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Choose default app if not set
      String? defaultApp = ProxyService.box.readString(key: 'defaultApp');
      if (defaultApp == null) {
        final dialogService = locator<DialogService>();
        final response = await dialogService.showCustomDialog(
          variant: DialogType.appChoice,
          title: 'Choose Your Default App',
        );

        if (response?.confirmed == true && response?.data != null) {
          defaultApp = response!.data['defaultApp'];
          await ProxyService.box.writeString(key: 'defaultApp', value: defaultApp!);
        } else {
          // User cancelled app choice, maybe default to POS or stay here
          setState(() => _isLoading = false);
          return; // Stop if no app is chosen
        }
      }

      // Handle POS shift logic
      if (defaultApp == 'POS') {
        final userId = ProxyService.box.getUserId();
        if (userId != null) {
          final currentShift =
              await ProxyService.strategy.getCurrentShift(userId: userId);
          if (currentShift == null) {
            final dialogService = locator<DialogService>();
            final response = await dialogService.showCustomDialog(
              variant: DialogType.startShift,
              title: 'Start New Shift',
            );
            if (response?.confirmed == true) {
              final openingBalance =
                  response?.data['openingBalance'] as double? ?? 0.0;
              final notes = response?.data['notes'] as String?;
              await ProxyService.strategy.startShift(
                userId: userId,
                openingBalance: openingBalance,
                note: notes,
              );
               _completeAuthenticationFlow();
            } else {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content:
                      Text('Shift not started. Please start a shift to proceed.'),
                  backgroundColor: Colors.orange,
                ),
              );
              setState(() => _isLoading = false);
              return;
            }
          } else {
            _completeAuthenticationFlow();
          }
        } else {
          _completeAuthenticationFlow();
        }
      } else {
        // For other apps, complete flow directly
        _completeAuthenticationFlow();
      }
    } catch (e) {
      talker.error('Error handling branch selection: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingItemId = null;
          // Do not set _isLoading to false here if a navigation is happening
        });
      }
    }
  }

  Future<void> _setDefaultBusiness(Business business) async {
    ref.read(businessSelectionProvider.notifier).setLoading(true);

    try {
      // First make all businesses inactive
      await _updateAllBusinessesInactive();
      // Then set the selected business as active and default
      await _updateBusinessActive(business);
      // Update preferences
      await _updateBusinessPreferences(business);
      // Refresh providers to reflect changes
      _refreshBusinessAndBranchProviders();
    } catch (e) {
      talker.error('Error setting default business: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        rethrow;
      }
    } finally {
      if (mounted) {
        ref.read(businessSelectionProvider.notifier).setLoading(false);
      }
    }
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);

    try {
      // First make all branches inactive
      await _updateAllBranchesInactive();
      // Then set the selected branch as active and default
      await _updateBranchActive(branch);
      // Update branch ID in storage
      await ProxyService.box.writeInt(key: 'branchId', value: branch.serverId!);
      await ProxyService.box
          .writeString(key: 'branchIdString', value: branch.id);
      // Set switched flag for other components to detect
      await ProxyService.box.writeBool(key: 'branch_switched', value: true);
      await ProxyService.box.writeInt(
          key: 'last_branch_switch_timestamp',
          value: DateTime.now().millisecondsSinceEpoch);
      await ProxyService.box
          .writeInt(key: 'active_branch_id', value: branch.serverId!);
      // Refresh providers to reflect changes
      _refreshBusinessAndBranchProviders();
    } catch (e) {
      talker.error('Error setting default branch: $e');
    } finally {
      ref.read(branchSelectionProvider.notifier).setLoading(false);
    }
  }

  Future<void> _updateAllBusinessesInactive() async {
    final businesses = await ProxyService.strategy
        .businesses(userId: ProxyService.box.getUserId()!);
    for (final business in businesses) {
      await ProxyService.strategy.updateBusiness(
        businessId: business.serverId,
        active: false,
        isDefault: false,
      );
    }
  }

  Future<void> _updateBusinessActive(Business business) async {
    await ProxyService.strategy.updateBusiness(
      businessId: business.serverId,
      active: true,
      isDefault: true,
    );
  }

  Future<void> _updateBusinessPreferences(Business business) async {
    // Get existing tin value if available
    final existingTin = ProxyService.box.readInt(key: 'tin');

    ProxyService.box
      ..writeInt(key: 'businessId', value: business.serverId)
      ..writeString(
          key: 'bhfId', value: (await ProxyService.box.bhfId()) ?? "00");

    // Only update tin if business.tinNumber is not null or there's no existing value
    if (business.tinNumber != null || existingTin == null) {
      ProxyService.box
          .writeInt(key: 'tin', value: business.tinNumber ?? existingTin ?? 0);
      talker.debug(
          'Setting tin to ${business.tinNumber ?? existingTin ?? 0} (from ${business.tinNumber != null ? 'business' : 'existing value'})');
    } else {
      talker.debug('Preserving existing tin value: $existingTin');
    }

    ProxyService.box
        .writeString(key: 'encryptionKey', value: business.encryptionKey ?? "");
  }

  Future<void> _updateAllBranchesInactive() async {
    final branches = await ProxyService.strategy
        .branches(businessId: ProxyService.box.getBusinessId()!, active: true);
    for (final branch in branches) {
      ProxyService.strategy.updateBranch(
          branchId: branch.serverId!, active: false, isDefault: false);
    }
  }

  Future<void> _updateBranchActive(Branch branch) async {
    await ProxyService.strategy.updateBranch(
        branchId: branch.serverId!, active: true, isDefault: true);
  }

  void _completeAuthenticationFlow() {
    // Track login event with PosthogService
    PosthogService.instance.capture('login_success', properties: {
      'source': 'login_choices',
      if (_selectedBusiness != null) 'business_id': _selectedBusiness!.serverId,
    });

    // Use pushReplacementNamed to completely replace the current screen
    // This prevents the branch selection from reappearing momentarily
    // Navigator.of(context).pushReplacementNamed(FlipperAppRoute().path);

    _routerService.navigateTo(FlipperAppRoute());

    // Clear the navigation flag after a delay
    Future.delayed(const Duration(seconds: 2), () {
      ProxyService.box
          .writeBool(key: 'branch_navigation_in_progress', value: false);
    });
  }

  void _refreshBusinessAndBranchProviders() {
    ref.refresh(businessesProvider);
    ref.refresh(branchesProvider(businessId: ProxyService.box.getBusinessId()));
  }
}
