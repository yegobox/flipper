import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

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
  bool isFavorite = false;
  bool isFirstRowBuilt = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavoriteViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => FavoriteViewModel(),
      onViewModelReady: (model) async {},
      builder: (context, model, child) {
        return Scaffold(
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              // Display two items on each row
              if (index.isEven) {
                // Add a container to the first row only
                if (!isFirstRowBuilt) {
                  isFirstRowBuilt = true;
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              'assets/checkout.svg',
                              height: 80,
                              width: 80,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Arrange your favorites",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Press and hold anywhere in the grid to begin adding items",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // Display two items on all other even rows
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
          floatingActionButton: hasBeenPressed
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      child: Text('Done',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff006AFE)),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blue.withOpacity(0.04);
                            }
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)) {
                              return Colors.blue.withOpacity(0.12);
                            }
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () async {},
                    ),
                  ),
                )
              : null,
          floatingActionButtonAnimator: null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
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
      child: isFavorite
          ? Container(
              height: 100,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Sample Text',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Sample Text',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
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
                      FluentIcons.add_20_regular,
                      color: Colors.blue[400],
                    )
                ],
              ),
            ),
    );
  }
}
