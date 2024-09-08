import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
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
    return Container(
      key: key,
      width: 80.0,
      height: 70.0,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xff006AFE) : Colors.white,
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
  @override
  IconRowState createState() => IconRowState();
}

class IconRowState extends ConsumerState<IconRow> with CoreMiscellaneous {
  final List<bool> _isSelected = [true, false, false, false, false];
  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  @override
  Widget build(BuildContext context) {
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
                _showBranchPerformanceMobile(context);
              } else {
                _showBranchPerformance(context);
              }
            }),
          ],
          onPressed: _onTogglePressed,
          isSelected: _isSelected,
          color: Colors.white,
          fillColor: Colors.white,
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
    if (index == 3) {
      _routerService.navigateTo(ReportsRoute());
    } else if (index == 2) {
      final data = await ProxyService.realm
          .getTransactionsAmountsSum(period: TransactionPeriod.today);
      final drawer = await ProxyService.local
          .getDrawer(cashierId: ProxyService.box.getUserId()!);

      if (drawer != null) {
        ProxyService.realm.realm!
            .write(() => drawer.closingBalance = data.income);
        _routerService
            .navigateTo(DrawerScreenRoute(open: "close", drawer: drawer));
      } else {
        await logOut();
        _routerService.navigateTo(LoginRoute());
      }
    }
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

  void _showBranchPerformance(BuildContext context) {
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
                SizedBox(
                  width: double.infinity,
                  height: 800,
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
