import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:sliding_switch/sliding_switch.dart';
import './search_view_model.dart';

// FIXME:{Telesphore} make looks like square Search
class SearchView extends StatelessWidget {
  const SearchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, SearchViewModel model, Widget child) {
          return Container(
              child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: model.searchController,
                    style: const TextStyle(color: Color(0xFF1F2227)),
                    decoration: InputDecoration(
                        hintText: 'Search ',
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesome.search,
                          color: Colors.grey[500],
                          size: 20.0,
                        )),
                  ),
                ),
              ),
            ],
          ));
        },
        viewModelBuilder: () => SearchViewModel());
  }
}
