// ignore_for_file: unused_result

import 'dart:developer';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoginChoices extends StatefulHookConsumerWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  _AppleInspiredLoginFlowState createState() => _AppleInspiredLoginFlowState();
}

class _AppleInspiredLoginFlowState extends ConsumerState<LoginChoices> {
  bool _isSelectingBranch = false;
  Business? _selectedBusiness; // Define selectedBusiness here
  String? _loadingItemId; // New state to track which item is loading

  final _routerService = locator<RouterService>();
  final talker = Talker();

  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(branchesProvider);
    final businesses = ref.watch(businessesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isSelectingBranch ? 'Choose a Branch' : 'Choose a Business',
                style: TextStyle(
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
                    ? _buildBranchList(branches: branches)
                    : _buildBusinessList(businesses: businesses),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessList({required List<Business> businesses}) {
    return ListView.separated(
      itemCount: businesses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final business = businesses[index];
        return _buildSelectionTile(
          title: business.name!,
          isSelected: business == _selectedBusiness,
          onTap: () async {
            setState(() {
              _selectedBusiness = business;
              _loadingItemId = business.serverId?.toString();
            });
            await chooseBusiness(business: business);
            setState(() {
              _loadingItemId = null;
            });
          },
          icon: Icons.business,
          isLoading: _loadingItemId == business.serverId?.toString(),
        );
      },
    );
  }

  Widget _buildBranchList({required List<Branch> branches}) {
    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final branch = branches[index];
        return _buildSelectionTile(
          title: branch.name!,
          isSelected: branch.isDefault,
          onTap: () async {
            setState(() {
              _loadingItemId = branch.serverId?.toString();
            });
            await chooseBranch(branch: branch);
            setState(() {
              _loadingItemId = null;
            });
          },
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
            boxShadow: [
              if (isSelected)
                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8.0),
            ],
          ),
          child: Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              else
                Icon(icon, color: isSelected ? Colors.blue : Colors.grey[600]),
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

  Future<void> setDefaultBusiness({required Business business}) async {
    ref.read(businessSelectionProvider.notifier).setLoading(true);

    try {
      ProxyService.local.localRealm!.write(() {
        final branches = ProxyService.local.businesses();
        branches.forEach((buss) {
          buss.isDefault = false;
          buss.active = false;
        });
        business.isDefault = true;
        business.active = true;
      });
      if (ProxyService.local.localRealm == null ||
          ProxyService.realm.realm == null) {
        await ProxyService.local.login(
            userPhone: ProxyService.box.getUserPhone()!,
            skipDefaultAppSetup: false);
      }

      ProxyService.box.writeInt(key: 'businessId', value: business.serverId!);
      ProxyService.box
          .writeString(key: 'bhfId', value: ProxyService.box.bhfId() ?? "00");
      ProxyService.box.writeInt(key: 'tin', value: business.tinNumber ?? 0);

      ProxyService.box
          .writeString(key: 'encryptionKey', value: business.encryptionKey!);

      ref.refresh(businessesProvider);
      ref.refresh(branchesProvider);
    } catch (e) {
      log(e.toString());
    } finally {
      ref.refresh(businessesProvider);
      ref.refresh(branchesProvider);
      ref.read(businessSelectionProvider.notifier).setLoading(false);
    }
  }

  Future<void> chooseBusiness({required Business business}) async {
    try {
      ref.read(businessSelectionProvider.notifier).setLoading(true);

      await setDefaultBusiness(business: business);

      // Check if there is only one business
      List<Business> businesses = ProxyService.local.businesses();
      if (businesses.length == 1) {
        // Automatically proceed to branch selection
        await _navigateToBranchSelection();
      } else {
        // Wait for a while before navigating, if needed
        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    } finally {
      ref.read(businessSelectionProvider.notifier).setLoading(false);
    }
  }

  Future<void> _navigateToBranchSelection() async {
    // Ensure branches are loaded
    final branches = ref.watch(branchesProvider);

    // Check if there are branches available
    if (branches.isNotEmpty) {
      setState(() {
        _isSelectingBranch = true; // Change state to select branch
      });
    } else {
      // Handle case where no branches are available, if needed
      // For example, show a message or handle error
    }
  }

  Future<void> setDefaultBranch({required Branch branch}) async {
    talker.warning("The choosen branch:${branch.serverId}");
    await ProxyService.box.writeInt(key: 'branchId', value: branch.serverId!);
    try {
      ProxyService.local.localRealm!.write(() {
        final branches = ProxyService.local
            .branches(businessId: ProxyService.box.getBusinessId());
        branches.forEach((branch) {
          branch.isDefault = false;
        });
        branch.isDefault = true;
      });
      ref.refresh(businessesProvider);
      ref.refresh(branchesProvider);

      /// re-sync with database to get the data required for the choosen branch/business
      await ProxyService.realm.configure(
        useInMemoryDb: false,
        useFallBack: false,
        branchId: ProxyService.box.getBranchId(),
        userId: ProxyService.box.getUserId(),
        businessId: ProxyService.box.getBusinessId(),
        encryptionKey: ProxyService.box.encryptionKey(),
      );

      ref.refresh(businessesProvider);
      ref.refresh(branchesProvider);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    } finally {
      ref.refresh(businessesProvider);
      ref.refresh(branchesProvider);
      ref.read(branchSelectionProvider.notifier).setLoading(false);
    }
  }

  Future<void> chooseBranch({required Branch branch}) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);

    await setDefaultBranch(branch: branch);

    /// This help when we restart the app do not come to auth flow for second time
    ProxyService.box.writeBool(key: "authComplete", value: true);

    if (ProxyService.realm.isDrawerOpen(
        cashierId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!)) {
      _routerService.navigateTo(FlipperAppRoute());
    } else {
      Drawers drawer = Drawers(
        ObjectId(),
        id: randomNumber(),
        openingBalance: 0.0,
        closingBalance: 0.0,
        cashierId: ProxyService.box.getUserId()!,
        tradeName: ProxyService.app.business.name,
        openingDateTime: DateTime.now().toIso8601String(),
        open: true,
        businessId: ProxyService.box.getBusinessId(),
        branchId: ProxyService.box.getBranchId(),
      );

      _routerService
          .navigateTo(DrawerScreenRoute(open: "open", drawer: drawer));
    }
  }
}
