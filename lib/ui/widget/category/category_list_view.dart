import 'package:flipper/ui/widget/category/category_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper/ui/widget/search/search_view.dart';

class ListCategoryView extends StatelessWidget {
  const ListCategoryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, ListCategoryViewModel model, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'List of Category', // title
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.grey[800]),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [],
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        // Add navabr
                        const SearchView(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RaisedButton(
                            onPressed: null,
                            elevation: 0.0,
                            color: Colors.blue[300],
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('Create Category',
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.blue[200],
                                          fontSize: 20.0))),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Divider(color: Colors.grey[600])),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('Benz',
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            color: Colors.grey[800]))),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(children: [
                                  const Expanded(
                                      child: Icon(FontAwesome.chevron_right,
                                          size: 20)),
                                ]),
                              ),
                            ],
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
        viewModelBuilder: () => ListCategoryViewModel());
  }
}
