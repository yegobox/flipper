// ignore_for_file: unused_result

import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoginChoices extends StatefulHookConsumerWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  _LoginChoicesState createState() => _LoginChoicesState();
}

class _LoginChoicesState extends ConsumerState<LoginChoices> {
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
        final branches = ref.watch(branchesProvider((includeSelf: true)));

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
                              ? _buildBranchList(branches: branches.value!)
                              : _buildBusinessList(businesses: businesses),
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

  Widget _buildBusinessList({required List<Business> businesses}) {
    return ListView.separated(
      itemCount: businesses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final business = businesses[index];
        return _buildSelectionTile(
          title: business.isValid ? business.name! : "",
          isSelected: business == _selectedBusiness,
          onTap: () => _handleBusinessSelection(business),
          icon: Icons.business,
          isLoading: _loadingItemId ==
              (business.isValid ? business.serverId?.toString() : false),
        );
      },
    );
  }

  Widget _buildBranchList({required List<Branch> branches}) {
    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final branch = branches[index];
        return _buildSelectionTile(
          title: branch.name!,
          isSelected: branch.isDefault,
          onTap: () => _handleBranchSelection(branch),
          icon: Icons.location_on,
          isLoading: _loadingItemId == branch.serverId?.toString(),
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
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.3), blurRadius: 8.0)
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

  void _handleBusinessSelection(Business business) async {
    setState(() {
      _selectedBusiness = business;
      _loadingItemId = business.serverId?.toString();
    });

    try {
      await _setDefaultBusiness(business);
      if (ProxyService.local.businesses().length == 1) {
        _navigateToBranchSelection();
      }
    } finally {
      setState(() {
        _loadingItemId = null;
      });
    }
  }

  void _handleBranchSelection(Branch branch) async {
    setState(() {
      _loadingItemId = branch.serverId?.toString();
    });

    try {
      await _setDefaultBranch(branch);
      _completeAuthenticationFlow();
    } finally {
      setState(() {
        _loadingItemId = null;
      });
    }
  }

  Future<void> _setDefaultBusiness(Business business) async {
    ref.read(businessSelectionProvider.notifier).setLoading(true);

    try {
      _updateAllBusinessesInactive();
      await _updateBusinessActive(business);
      _updateBusinessPreferences(business);
      _refreshBusinessAndBranchProviders();
    } catch (e) {
      log(e.toString());
    } finally {
      ref.read(businessSelectionProvider.notifier).setLoading(false);
    }
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);

    try {
      await _updateAllBranchesInactive();
      await _updateBranchActive(branch);
      await _syncBranchWithDatabase(branch);
      setState(() {
        _isLoading = true;
      });
      _refreshBusinessAndBranchProviders();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    } finally {
      ref.read(branchSelectionProvider.notifier).setLoading(false);
    }
  }

  void _updateAllBusinessesInactive() {
    final businesses = ProxyService.local.businesses();
    for (final business in businesses) {
      ProxyService.local.realm!.write(() {
        business.active = false;
        business.isDefault = false;
      });
    }
  }

  Future<void> _updateBusinessActive(Business business) async {
    ProxyService.local.realm!.write(() {
      business.isDefault = true;
      business.active = true;
    });
  }

  Future<void> _updateBusinessPreferences(Business business) async {
    ProxyService.box
      ..writeInt(key: 'businessId', value: business.serverId!)
      ..writeString(key: 'bhfId', value: await ProxyService.box.bhfId() ?? "00")
      ..writeInt(key: 'tin', value: business.tinNumber ?? 0)
      ..writeString(key: 'encryptionKey', value: business.encryptionKey!);
  }

  Future<void> _updateAllBranchesInactive() async {
    final branches = await ProxyService.local.branches(
        businessId: ProxyService.box.getBusinessId()!, includeSelf: true);
    for (final branch in branches) {
      ProxyService.local.realm!.write(() {
        branch.active = false;
        branch.isDefault = false;
      });
    }
  }

  Future<void> _updateBranchActive(Branch branch) async {
    ProxyService.local.realm!.write(() {
      branch.isDefault = true;
      branch.active = true;
    });
  }

  Future<void> _syncBranchWithDatabase(Branch branch) async {
    await ProxyService.box.writeInt(key: 'branchId', value: branch.serverId!);
  }

  void _navigateToBranchSelection() {
    setState(() {
      _isSelectingBranch = true;
    });
    ref.refresh(branchesProvider((includeSelf: true)));
  }

  void _completeAuthenticationFlow() {
    _routerService.navigateTo(FlipperAppRoute());
    // if (ProxyService.local.isDrawerOpen(
    //     cashierId: ProxyService.box.getUserId()!,
    //     branchId: ProxyService.box.getBranchId()!)) {
    //   _routerService.navigateTo(FlipperAppRoute());
    // } else {
    //   Drawers drawer = Drawers(
    //     ObjectId(),
    //     id: randomNumber(),
    //     openingBalance: 0.0,
    //     closingBalance: 0.0,
    //     cashierId: ProxyService.box.getUserId()!,
    //     tradeName: ProxyService.app.business.name,
    //     openingDateTime: DateTime.now().toIso8601String(),
    //     open: true,
    //     businessId: ProxyService.box.getBusinessId(),
    //     branchId: ProxyService.box.getBranchId(),
    //   );

    //   _routerService
    //       .navigateTo(DrawerScreenRoute(open: "open", drawer: drawer));
    // }
  }

  void _refreshBusinessAndBranchProviders() {
    ref.refresh(businessesProvider);
    ref.refresh(branchesProvider((includeSelf: true)));
  }
}
