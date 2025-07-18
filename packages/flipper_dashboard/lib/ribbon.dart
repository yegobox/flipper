// ignore_for_file: unused_result, unused_field

import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/Reports.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_dashboard/transaction_list_wrapper.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show
        branchSelectionProvider,
        businessesProvider,
        buttonIndexProvider,
        selectedBranchProvider;
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
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
  final List<bool> _isSelected = [true, false, false, false, false, false];
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
            _buildIconText(context, Icons.sync_outlined, 'Reports', 1,
                const Key('reports_desktop')),
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
            _buildIconText(context, Icons.inventory_2_outlined, 'Items', 5,
                const Key('items_desktop'), () {
              final dialogService = locator<DialogService>();
              dialogService.showCustomDialog(
                variant: DialogType.items,
              );
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
        context: context,
        builder: (BuildContext context) {
          return const ReportsDashboardDialogWrapper();
        },
      );
    } else if (index == 2) {
      showBranchSwitchDialog(
        context: context,
        branches: null, // Now allowed: nullable
        loadingItemId: _loadingItemId,
        setDefaultBranch: (branch) async {
          setState(() {
            _isLoading = true;
          });
          handleBranchSelection(
            branch,
            context,
            setLoadingState: (String? id) {
              setState(() {
                _loadingItemId = id;
              });
            },
            setDefaultBranch: _setDefaultBranch,
            onComplete: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
            },
            setIsLoading: (bool value) {
              setState(() {
                _isLoading = value;
              });
            },
          );
        },
        handleBranchSelection: handleBranchSelection, // Pass required argument
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

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);
    _refreshBusinessAndBranchProviders();
    return Future.value(); // Return a completed Future<void>
  }

  void _refreshBusinessAndBranchProviders() {
    ref.refresh(businessesProvider);
    ref.refresh(branchesProvider(businessId: ProxyService.box.getBusinessId()));
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: TransactionListWrapper(showDetailedReport: true),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minWidth: 400, // Optional: for desktop/tablet
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SystemConfig(showheader: false),
            ),
          ),
        ),
      ),
    );
  }
}
