import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'dart:developer';
import 'animated_row.dart';

class Favorites extends StatefulWidget {
  Favorites({Key? key, this.hasBeenPressed = false}) : super(key: key);
  bool hasBeenPressed;
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  // Define a list of items to be displayed in the ListView
  final List<String> items = List.generate(16, (index) => 'Item ${index}');

  // Define a boolean to know if we have pressed.

  List<int> favoriteProdIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavoriteViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => FavoriteViewModel(),
      onViewModelReady: (model) async {
        model.getFavorites();
      },
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  // Display two items on each row
                  if (index.isEven) {
                    // Add a container to the first row only
                    if (index == 0 && !widget.hasBeenPressed) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/checkout.svg',
                                  height: 80,
                                  width: 80,
                                  package: 'flipper_dashboard',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Arrange your favorites",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10),
                              Wrap(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    widget.hasBeenPressed
                                        ? 'Press "Done" when you are finished'
                                        : "Press and hold anywhere in the grid to begin setting items",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ]),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Display two items on all other even rows
                      if (widget.hasBeenPressed) {
                        //Setting widget.hasBeenPressed has bizarre effect on indices.
                        //The top block is actually deleted, leaving a void of
                        //indices -2, which messes up the favorite blocks.
                        //This has been catered for.
                        return Row(
                          children: [
                            Expanded(
                                child: AnimatedRowItem(
                              item: _buildItem(context, (index), model),
                            )),
                            Expanded(
                                child: AnimatedRowItem(
                                    item: _buildItem(
                                        context, (index + 1), model))),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                                child: AnimatedRowItem(
                                    item: _buildItem(
                                        context, (index - 2), model))),
                            Expanded(
                                child: AnimatedRowItem(
                                    item: _buildItem(
                                        context, (index - 1), model))),
                          ],
                        );
                      }
                    }
                  }
                  // Return an empty container for odd indices to keep the layout
                  return AnimatedContainer(
                    duration: Duration(microseconds: 1),
                  );
                },
              ),
              widget.hasBeenPressed
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 60,
                          width: double.infinity,
                          child: OutlinedButton(
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor),
                              child: Text('Done',
                                  style: primaryTextStyle.copyWith(
                                      color: Colors.white)),
                            ),
                            style: primaryButtonStyle.copyWith(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                widget.hasBeenPressed = false;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

//Function to transform color from hex string to Color
  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

//Function to build an empty grid item
  Widget _favoriteEmpty(int favIndex) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact();
        // Show a plus icon on long press to add the item to favorites
        setState(() {
          widget.hasBeenPressed = true;
        });
      },
      onTap: () {
        if (widget.hasBeenPressed) {
          // Launch the page where the item will be added to favorites.
          // It contains a modified ProductView widget.
          final _routerService = locator<RouterService>();
          _routerService.navigateTo(AddToFavoritesRoute(
              favoriteIndex: favIndex, existingFavs: favoriteProdIds));
        }
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
            if (widget.hasBeenPressed)
              Icon(FluentIcons.add_20_regular, color: Colors.blue[400])
          ],
        ),
      ),
    );
  }

//Function to build a populated grid item
  Widget _favoritePopulated(
      int favIndex, Product favProd, FavoriteViewModel model) {
    if (!favoriteProdIds.contains(favProd.id)) {
      favoriteProdIds.add(favProd.id!);
    }

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact();
        setState(() {
          widget.hasBeenPressed = true;
        });
      },
      onTap: () {
        if (widget.hasBeenPressed) {
          final _routerService = locator<RouterService>();
          _routerService.navigateTo(AddToFavoritesRoute(
              favoriteIndex: favIndex, existingFavs: favoriteProdIds));
        } else {
          final _routerService = locator<RouterService>();
          _routerService.navigateTo(SellRoute(product: favProd));
        }
      },
      child: Column(
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // Set the background color based on the condition
              color: favProd.imageUrl != null && !favProd.imageUrl!.isEmpty
                  ? null
                  : getColorFromHex(favProd.color),
              // Set the background image based on the condition
              image: favProd.imageUrl != null && !favProd.imageUrl!.isEmpty
                  ? DecorationImage(
                      image: NetworkImage(favProd.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    favProd.imageUrl != null && !favProd.imageUrl!.isEmpty
                        ? ''
                        : favProd.name.length > 1
                            ? favProd.name.substring(0, 2)
                            : favProd.name.toUpperCase(),
                    style:
                        GoogleFonts.poppins(fontSize: 36, color: Colors.white),
                  ),
                ),
                if (widget.hasBeenPressed)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          model.deleteFavoriteByIndex(favIndex);
                          favoriteProdIds.remove(favProd.id);
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Center(
            child: Text(favProd.name),
          ),
        ],
      ),
    );
  }

  Widget _buildItemContent(
      BuildContext context, int adjustedIndex, FavoriteViewModel model) {
    return StreamBuilder<Favorite?>(
      initialData: null,
      stream:
          ProxyService.isar.getFavoriteByIndexStream(favIndex: adjustedIndex),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _favoriteEmpty(adjustedIndex);
        } else {
          final favorite = snapshot.data!;
          int prodId = favorite.productId!;

          return StreamBuilder<Product?>(
            stream: ProxyService.isar.getProductStream(prodIndex: prodId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                Product favProduct = snapshot.data!;
                return _favoritePopulated(adjustedIndex, favProduct, model);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }

  // Builds an item widget with the given label and favorite status
  Widget _buildItem(
      BuildContext context, int favIndex, FavoriteViewModel model) {
    // Calculate the adjusted index based on the hasBeenPressed state
    int adjustedIndex = favIndex;

    return _buildItemContent(context, adjustedIndex, model);
  }
}
