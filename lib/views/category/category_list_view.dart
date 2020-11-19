import 'package:flipper/views/category/category_list_view_model.dart';
import 'package:flipper/widget/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

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
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600])),
                          child: RaisedButton(
                            child: const Text(' Create category '),
                            onPressed: () {},
                            color: Colors.grey[200],
                            textColor: Colors.blue[600],
                            splashColor: Colors.grey,
                            padding: const EdgeInsets.all(15.0),
                          ),
                        ),
                        //
                        const SizedBox(
                          height: 30.0,
                        ),
                        listCategory(name: 'Benz', context: context),

                        listCategory(name: 'Benz', context: context),
                        const SizedBox(
                          height: 10.0,
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

  // List of category
  Widget listCategory({@required String name, BuildContext context}) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.grey[300]),
        )),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(name,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).hintColor))),
            ),
            Expanded(
              flex: 1,
              child: Row(children: [
                const Expanded(
                    child: Icon(FontAwesome.chevron_right, size: 20)),
              ]),
            ),
            Divider(
              color: Colors.grey[400],
            )
          ],
        ),
      ),
    );
  }
}
