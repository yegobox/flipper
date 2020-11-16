import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:sliding_switch/sliding_switch.dart';
import './search_view_model.dart';

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
                height: 40,
                child: TextField(
                  controller: model.searchController,
                  style: TextStyle(color: Colors.grey[600]),
                  decoration: InputDecoration(
                      hintText: 'Search Items',
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesome.search,
                        color: Colors.grey[600],
                        size: 14.0,
                      )),
                ),
              ),
              Divider(
                color: Colors.grey[600],
              )
            ],
          ));
        },
        viewModelBuilder: () => SearchViewModel());
  }
}
