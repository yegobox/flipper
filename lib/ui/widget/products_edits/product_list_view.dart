import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/ui/widget/search/search_view.dart';
import 'product_list_view_model.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ProductsViewModel model, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'List Items', // title
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                    child: Column(
                      children: [
                        // Add navabr
                        const SearchView(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => ProductsViewModel());
  }
}
