import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

class AddToFavorites extends StatelessWidget {
  final int favoriteIndex;
  final List<int> existingFavs; // Make this field 'final'

  AddToFavorites({
    Key? key,
    required this.favoriteIndex,
    required this.existingFavs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Text('Set Favorite Product',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Expanded(
              child: ProductView.favoriteMode(
                favIndex: favoriteIndex,
                existingFavs: existingFavs,
              ),
            ),
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                final _routerService = locator<RouterService>();
                _routerService.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
