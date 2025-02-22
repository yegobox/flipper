// ignore_for_file: unused_result, unused_field

import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/Reports.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show
        branchSelectionProvider,
        branchesProvider,
        businessesProvider,
        buttonIndexProvider,
        selectedBranchProvider;
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart' show TransactionPeriod;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:flipper_routing/app.router.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final Key key;

  const IconText({
    required this.icon,
    required this.text,
    required this.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      key: key,
      width: 80.0,
      height: 70.0,
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 20.0,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}

class IconRow extends StatefulHookConsumerWidget {
  const IconRow({super.key});

  @override
  ConsumerState<IconRow> createState() => IconRowState();
}

class IconRowState extends ConsumerState<IconRow>
    with CoreMiscellaneous, BranchSelectionMixin {
  final List<bool> _isSelected = [true, false, false, false, false];
  String? _loadingItemId; // Add this
  bool _isLoading = false;

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleButtons(
          selectedColor: Colors.red,
          children: [
            _buildIconText(context, Icons.home_outlined, 'Home', 0,
                const Key('home_desktop'), () {
              _showTaxDialog(context);
            }),
            _buildIconText(context, Icons.sync_outlined, 'Z Report', 1,
                const Key('zreport_desktop')),
            _buildIconText(context, Icons.payment_outlined, 'EOD', 2,
                const Key('eod_desktop')),
            _buildIconText(context, Icons.dashboard_outlined, 'Reports', 3,
                const Key('reports_desktop')),
            _buildIconText(context, Icons.maps_home_work_outlined, 'Locations',
                4, const Key('locations'), () {
              final deviceType = _getDeviceType(context);
              if (deviceType == 'Phone' || deviceType == 'Phablet') {
                ref.read(selectedBranchProvider.notifier).state = null;
                _showBranchPerformanceMobile(context);
              } else {
                _showBranchPerformance(context);
              }
            }),
          ],
          onPressed: _onTogglePressed,
          isSelected: _isSelected,
          color: colorScheme.surface,
          fillColor: colorScheme.surface,
        ),
      ],
    );
  }

  GestureDetector _buildIconText(
      BuildContext context, IconData icon, String text, int index, Key key,
      [VoidCallback? onDoubleTap]) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: IconText(
        icon: icon,
        text: text,
        key: key,
        isSelected: _isSelected[index],
      ),
    );
  }

  void _onTogglePressed(int index) {
    ref.read(buttonIndexProvider.notifier).setIndex(index);

    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i == index;
      }
    });

    _navigateBasedOnIndex(index);
  }

  final _routerService = locator<RouterService>();

  Future<void> _navigateBasedOnIndex(int index) async {
    if (index == 1) {
      _showReport(context);
    }
    if (index == 3) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 700),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReportsDashboard(),
            ),
          ),
        ),
      );
    } else if (index == 2) {
      final data = await ProxyService.strategy
          .getTransactionsAmountsSum(period: TransactionPeriod.today);
      final drawer = await ProxyService.strategy
          .getDrawer(cashierId: ProxyService.box.getUserId()!);

      if (drawer != null) {
        ProxyService.strategy.updateDrawer(
          drawerId: drawer.id,
          closingBalance: data.income,
          cashierId: ProxyService.box.getUserId()!,
        );
        _routerService
            .replaceWith(DrawerScreenRoute(open: "close", drawer: drawer));
      } else {
        // Show branch switching dialog with logout option
        await showBranchSwitchDialog(
          context: context,
          branches: await ProxyService.strategy.branches(
              businessId: ProxyService.box.getBusinessId()!,
              includeSelf: false),
          loadingItemId: _loadingItemId,
          setDefaultBranch: (branch) async {
            setState(() {
              _isLoading = true; // Correctly set loading state here
            });
            handleBranchSelection(
              branch: branch,
              context: context,
              setLoadingState: (String? id) {
                setState(() {
                  _loadingItemId = id;
                });
              },
              setDefaultBranch: _setDefaultBranch,
              onComplete: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _isLoading = false; // Correctly set loading state here
                });
              },
              setIsLoading: (bool value) {
                setState(() {
                  _isLoading = value;
                });
              },
            );
          },
          onLogout: () async {
            await showLogoutConfirmationDialog(
              context,
            );
          },
          setLoadingState: (String? id) {
            setState(() {
              _loadingItemId = id;
            });
          },
        );
      }
    }
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);
    _refreshBusinessAndBranchProviders();
    return Future.value(); // Return a completed Future<void>
  }

  void _refreshBusinessAndBranchProviders() {
    ref.refresh(businessesProvider);
    ref.refresh(branchesProvider((includeSelf: true)));
  }

  void _showBranchPerformanceMobile(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            resizeToAvoidBottomInset: true,
            enableDrag: true,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: double.infinity),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 800,
                      child: BranchPerformance(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        return WoltModalType.dialog();
      },
      onModalDismissedWithBarrierTap: () {
        Navigator.of(context).pop();
      },
      barrierDismissible: true,
    );
  }

  void _showReport(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TransactionList(showDetailedReport: true),
          ),
        ),
      ),
    );
  }

  void _showBranchPerformance(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: BranchPerformance(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaxDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TaxConfiguration(showheader: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
