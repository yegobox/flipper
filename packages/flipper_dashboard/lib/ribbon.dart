// ignore_for_file: unused_result, unused_field

import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/import_purchase_dialog.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/providers/app_mode_provider.dart';
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
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final primary = PosLayoutBreakpoints.posAccentBlue;

    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? primary : Colors.black54,
            size: 20.0,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? primary : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13.0,
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
  /// Selection for main ribbon tabs: Home, Transactions, EOD, Analytics.
  final List<bool> _selectedMain = [true, false, false, false];
  String? _loadingItemId;
  bool _isLoading = false;

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  int _legacyButtonIndexForUi(int uiIndex) {
    if (uiIndex < 0 || uiIndex > 3) return 0;
    return uiIndex;
  }

  void _onMainTabPressed(int uiIndex) {
    ref
        .read(buttonIndexProvider.notifier)
        .setIndex(_legacyButtonIndexForUi(uiIndex));
    setState(() {
      for (var i = 0; i < 4; i++) {
        _selectedMain[i] = i == uiIndex;
      }
    });
    _runNavigationForUi(uiIndex);
  }

  void _runNavigationForUi(int uiIndex) {
    switch (uiIndex) {
      case 0:
        break;
      case 1:
        _showReport(context);
        break;
      case 2:
        showBranchSwitchDialog(
          context: context,
          branches: null,
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
          handleBranchSelection: handleBranchSelection,
          onLogout: () async {
            await showLogoutConfirmationDialog(context);
          },
          setLoadingState: (String? id) {
            setState(() {
              _loadingItemId = id;
            });
          },
        );
        break;
      case 3:
        preloadReportsData(ref);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => const FastReportsDialog(),
        );
        break;
    }
  }

  Widget _buildMainTab(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int uiIndex,
    required Key key,
    VoidCallback? onDoubleTap,
  }) {
    return InkWell(
      onTap: () => _onMainTabPressed(uiIndex),
      onDoubleTap: onDoubleTap,
      borderRadius: BorderRadius.circular(8),
      child: IconText(
        icon: icon,
        text: label,
        key: key,
        isSelected: _selectedMain[uiIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final appMode = ref.watch(appModeProvider);
    final showImportPurchase =
        deviceType != 'Phone' && deviceType != 'Phablet' && appMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildMainTab(
          context,
          icon: Icons.home_outlined,
          label: 'Home',
          uiIndex: 0,
          key: const Key('home_desktop'),
          onDoubleTap: () => _showTaxDialog(context),
        ),
        const SizedBox(width: 4),
        _buildMainTab(
          context,
          icon: Icons.sync_outlined,
          label: 'Transactions',
          uiIndex: 1,
          key: const Key('transactions_desktop'),
        ),
        const SizedBox(width: 4),
        _buildMainTab(
          context,
          icon: Icons.payment_outlined,
          label: 'EOD',
          uiIndex: 2,
          key: const Key('eod_desktop'),
        ),
        const SizedBox(width: 4),
        _buildMainTab(
          context,
          icon: Icons.dashboard_outlined,
          label: 'Analytics',
          uiIndex: 3,
          key: const Key('analytics_desktop'),
        ),
        if (showImportPurchase) ...[
          const SizedBox(width: 4),
          Tooltip(
            message: 'Import & Purchase',
            child: InkWell(
              key: const Key('import_purchase_ribbon'),
              onTap: () => ImportPurchaseDialog.show(context),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Icon(
                  FluentIcons.expand_up_right_16_regular,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(width: 4),
        PopupMenuButton<String>(
          tooltip: 'More',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Icon(
              Icons.more_horiz,
              color: Colors.black54,
              size: 22,
            ),
          ),
          onSelected: (value) {
            if (value == 'locations') {
              _onMoreMenuLocations(context);
            } else if (value == 'items') {
              _onMoreMenuItems();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'locations',
              child: ListTile(
                dense: true,
                leading: Icon(Icons.maps_home_work_outlined),
                title: Text('Locations'),
              ),
            ),
            const PopupMenuItem(
              value: 'items',
              child: ListTile(
                dense: true,
                leading: Icon(Icons.inventory_2_outlined),
                title: Text('Items'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onMoreMenuLocations(BuildContext context) {
    ref.read(buttonIndexProvider.notifier).setIndex(4);
    final deviceType = _getDeviceType(context);
    if (deviceType == 'Phone' || deviceType == 'Phablet') {
      ref.read(selectedBranchProvider.notifier).state = null;
      _showBranchPerformanceMobile(context);
    } else {
      _showBranchPerformance(context);
    }
  }

  void _onMoreMenuItems() {
    ref.read(buttonIndexProvider.notifier).setIndex(5);
    final dialogService = locator<DialogService>();
    dialogService.showCustomDialog(variant: DialogType.items);
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);
    _refreshBusinessAndBranchProviders();
    return Future.value();
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
                  maxWidth: double.infinity,
                ),
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
        child: const _DeferredTransactionListDialogBody(),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minWidth: 400,
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

/// Opens the transactions dialog shell on the first frame, then mounts
/// [TransactionListWrapper] (full report chrome: KPIs, filters, cashier, export)
/// after layout so the modal appears immediately instead of blocking during
/// [showDialog].
class _DeferredTransactionListDialogBody extends ConsumerStatefulWidget {
  const _DeferredTransactionListDialogBody();

  @override
  ConsumerState<_DeferredTransactionListDialogBody> createState() =>
      _DeferredTransactionListDialogBodyState();
}

class _DeferredTransactionListDialogBodyState
    extends ConsumerState<_DeferredTransactionListDialogBody> {
  bool _mountList = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _mountList = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height * 0.9;
    final maxW = MediaQuery.sizeOf(context).width * 0.95;

    if (!_mountList) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH, maxWidth: maxW),
        child: const SizedBox(
          height: 360,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH, maxWidth: maxW),
      child: TransactionListWrapper(showDetailedReport: true),
    );
  }
}
