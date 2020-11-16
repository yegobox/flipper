import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper/routes/router.gr.dart';
import './itemsViewModel.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({Key key, @required this.userId, @required this.items})
      : super(key: key);
  final String userId;
  final bool items;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ItemViewModel model, Widget child) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      model.navigateTo(path: Routing.itemsListView);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('All Items',
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
                                child:
                                    Icon(FontAwesome.chevron_right, size: 20)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  //Categories
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      model.navigateTo(path: Routing.listCategoryView);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Categories',
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
                                child:
                                    Icon(FontAwesome.chevron_right, size: 20)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  //===Modifier
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Modifiers',
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
                              child: Icon(FontAwesome.chevron_right, size: 20)),
                        ]),
                      ),
                    ],
                  ),
                  // Discount
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      model.navigateTo(path: Routing.discountView);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Discounts',
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
                                child: Icon(
                              FontAwesome.chevron_right,
                              size: 20,
                            )),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  // Option
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Options',
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
                              child: Icon(
                            FontAwesome.chevron_right,
                            size: 20,
                          )),
                        ]),
                      ),
                    ],
                  ),
                  // Discount
                  Divider(
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Units',
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
                              child: Icon(
                            FontAwesome.chevron_right,
                            size: 20,
                          )),
                        ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => ItemViewModel());
  }
}
