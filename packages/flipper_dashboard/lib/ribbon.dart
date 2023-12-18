import 'package:flipper_dashboard/Stock.dart';
import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_models/isar_models.dart' as isar;

// Create a custom IconText widget that displays an icon and a text below it, with a border and a background color
class IconText extends StatelessWidget {
  // Declare the icon and text as final variables
  final IconData icon;
  final String text;

  // Create a constructor that takes the icon and text as arguments
  IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use width and height to set the size of the container
      width: 80.0,
      height: 70.0,
      // Use decoration to set the border and the background color of the container
      decoration: BoxDecoration(
        // border: Border.all(width: 1.0, color: Colors.grey),
        color: Color(0xff006AFE),
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
              color: Colors.white,
              size: 20.0,
            ),
          ),
          // Use text to display the text below the icon
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}

class IconRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      // Use mainAxisAlignment to control the alignment of the icons within the row
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // Use crossAxisAlignment to control the vertical alignment of the icons
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Use IconButton to wrap each IconText and provide a callback for onPressed

        IconButton(
          icon: IconText(
            icon: Icons.transfer_within_a_station,
            text: 'Transfer',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
            showAlert(context, onPressedOk: () {}, title: "Comming soon");
          },
        ),
        IconButton(
          icon: IconText(
            icon: Icons.local_offer,
            text: 'Discount',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
            showAlert(context, onPressedOk: () {}, title: "Comming soon");
          },
        ),

        IconButton(
          icon: IconText(
            icon: Icons.replay,
            text: 'Refund',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
            showAlert(context, onPressedOk: () {}, title: "Comming soon");
          },
        ),

        IconButton(
          icon: IconText(
            icon: Icons.sync,
            text: 'Stock',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
            // showAlert(context, onPressedOk: () {}, title: "Comming soon");
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => Stock(),
            //   ),
            // );
          },
        ),

        Spacer(), // Use Spacer to create space between the icons and align them properly
        IconButton(
          icon: IconText(
            icon: Icons.payment,
            text: 'EOD',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () async {
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
          },
        ),
      ],
    );
  }
}
