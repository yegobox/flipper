import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_models/isar_models.dart' as isar;

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
  List<bool> _isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleButtons(
          children: <Widget>[
            IconText(
              icon: Icons.home,
              text: 'Home',
              isSelected: _isSelected[0],
            ),
            // IconText(
            //   icon: Icons.local_offer,
            //   text: 'Discount',
            //   isSelected: _isSelected[1],
            // ),
            // IconText(
            //   icon: Icons.replay,
            //   text: 'Refund',
            //   isSelected: _isSelected[2],
            // ),
            ProxyService.isar.isTaxEnabled()
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
          ],
          onPressed: (int index) async {
            ref.read(buttonIndexProvider.notifier).setIndex(index);
            if (index == 0) {
              await ProxyService.realm.syncCounter();

              showSnackBar(context, "Your counter is up to date",
                  textColor: Colors.white, backgroundColor: Colors.green);
            }
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

            buttonNav(index);
          },
          isSelected: _isSelected,
          color: Colors.white,
          selectedColor: Colors.white,
          fillColor: Colors.white,
        ),
      ],
    );
  }

  void buttonNav(int index) async {
    // Handle button press
    if (index == 2) {
      final _routerService = locator<RouterService>();
      // Perform some action when the button is pressed
      final data = await ProxyService.isar
          .getTransactionsAmountsSum(period: TransactionPeriod.today);
      isar.Drawers? drawer = await ProxyService.isar.getDrawer(
        cashierId: ProxyService.box.getBusinessId()!,
      );
      if (drawer != null) {
        /// update the drawer with closing balance
        drawer.closingBalance = data.income;

        await ProxyService.isar.update(data: drawer);
      }
      _routerService
          .navigateTo(DrawerScreenRoute(open: "close", drawer: drawer!));
    }
  }
}
