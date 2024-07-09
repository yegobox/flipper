import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';

import 'bottom_sheets/SettingsBottomSheet.dart';

// Create a custom IconText widget that displays an icon and a text below it, with a border and a background color
class IconText extends StatelessWidget {
  // Declare the icon and text as final variables
  final IconData icon;
  final String text;
  final bool isSelected;

  // Create a constructor that takes the icon and text as arguments
  IconText({required this.icon, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use width and height to set the size of the container
      width: 80.0,
      height: 70.0,
      // Use decoration to set the border and the background color of the container
      decoration: BoxDecoration(
        // border: Border.all(width: 1.0, color: Colors.grey),
        color: isSelected ? Color(0xff006AFE) : Colors.white,
      ),
      // Use child to add a column widget inside the container
      child: Column(
        // Use mainAxisAlignment to control the alignment of the icon and the text within the column
        mainAxisAlignment: MainAxisAlignment.center,
        // Use crossAxisAlignment to control the horizontal alignment of the icon and the text
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Use padding to add some space around the icon
          Padding(
            padding: EdgeInsets.all(10.0),
            // Use icon to display the icon from a predefined set of icons or a custom icon font
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 20.0,
            ),
          ),
          // Use text to display the text below the icon
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

class IconRowState extends ConsumerState<IconRow> {
  List<bool> _isSelected = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleButtons(
          selectedColor: Colors.red,
          children: <Widget>[
            GestureDetector(
              onDoubleTap: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => Dialog(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // maxWidth: 400, // Adjust this value as needed
                        maxHeight: MediaQuery.of(context).size.height *
                            0.8, // 80% of screen height
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity, // Ensure full width
                                height: 800,
                                child: TaxConfiguration(
                                  showheader: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: IconText(
                icon: Icons.home,
                text: 'Home',
                isSelected: _isSelected[0],
              ),
            ),
            ProxyService.realm.isTaxEnabled()
                ? IconText(
                    icon: Icons.sync,
                    text: 'Z Report',
                    isSelected: _isSelected[1],
                  )
                : SizedBox.shrink(),
            IconText(
              icon: Icons.payment,
              text: 'EOD',
              isSelected: _isSelected[2],
            ),
            GestureDetector(
              onDoubleTap: () {},
              child: IconText(
                icon: Icons.dashboard,
                text: 'Reports',
                isSelected: _isSelected[3],
              ),
            ),
          ],
          onPressed: (int index) async {
            ref.read(buttonIndexProvider.notifier).setIndex(index);

            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < _isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  // ignore: unused_result
                  _isSelected[buttonIndex] = true;
                } else {
                  _isSelected[buttonIndex] = false;
                }
              }
            });

            buttonNav(index, context);
          },
          isSelected: _isSelected,
          color: Colors.white,
          fillColor: Colors.white,
        ),
      ],
    );
  }

  final _routerService = locator<RouterService>();

  void buttonNav(int index, context) async {
    if (index == 3) {
      _routerService.navigateTo(ReportsRoute());
    }
    if (index == 2) {
      // Perform some action when the button is pressed
      final data = await ProxyService.realm
          .getTransactionsAmountsSum(period: TransactionPeriod.today);
      Drawers? drawer = await ProxyService.realm.getDrawer(
        cashierId: ProxyService.box.getBusinessId()!,
      );
      if (drawer != null) {
        /// update the drawer with closing balance

        ProxyService.realm.realm!.write(() {
          drawer.closingBalance = data.income;
        });
      }
      _routerService
          .navigateTo(DrawerScreenRoute(open: "close", drawer: drawer!));
    }
  }
}
