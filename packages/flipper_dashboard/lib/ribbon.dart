import 'package:flutter/material.dart';

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
        color: Colors.black,
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
          // Use IconText to display each icon and text with a border and a background color
          icon: IconText(
            icon: Icons.search,
            text: 'Search',
          ),
          // Use iconSize to set the size of the icon button
          iconSize: 100.0,
          // Use padding to set the space around the icon button
          padding: EdgeInsets.zero,
          // Use onPressed to perform some action when the button is pressed
          onPressed: () {
            // Perform some action when the button is pressed
          },
        ),
        IconButton(
          icon: IconText(
            icon: Icons.transfer_within_a_station,
            text: 'Transfer',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
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
          },
        ),
        IconButton(
          icon: IconText(
            icon: Icons.cancel,
            text: 'Cancel',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
          },
        ),

        Spacer(), // Use Spacer to create space between the icons and align them properly
        IconButton(
          icon: IconText(
            icon: Icons.payment,
            text: 'Payment',
          ),
          iconSize: 100.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            // Perform some action when the button is pressed
          },
        ),
      ],
    );
  }
}
