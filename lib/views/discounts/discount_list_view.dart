

import 'package:flipper/views/discounts/discount_list_view_model.dart';
import 'package:flipper/widget/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class ListDiscountView extends StatelessWidget {
  const ListDiscountView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, ListDiscountViewModel model, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'List of Discounts', // title
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => ListDiscountViewModel());
  }
}
