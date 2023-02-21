import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  // Define a list of items to be displayed in the ListView
  final List<String> items = List.generate(16, (index) => 'Item ${index + 1}');

  // Define a boolean to know if we have pressed.
  bool hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Display two items on each row
          if (index.isEven) {
            return Row(
              children: [
                Expanded(child: _buildItem(context)),
                Expanded(child: _buildItem(context)),
              ],
            );
          }
          // Return an empty container for odd indices to keep the layout
          return Container();
        },
      ),
    );
  }

  // Builds an item widget with the given label and favorite status
  Widget _buildItem(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact();
        // Show a plus icon on long press to add the item to favorites
        setState(() {
          hasBeenPressed = true;
        });
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasBeenPressed)
              Icon(
                Icons.add,
                color: Colors.red,
                size: 40,
              )
          ],
        ),
      ),
    );
  }
}
