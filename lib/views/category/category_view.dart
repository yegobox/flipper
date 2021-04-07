import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/category/category_selecter_view.dart';
import 'package:flipper_models/view_models/add_product_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryView extends StatelessWidget {
  CategoryView({Key key, this.model}) : super(key: key);
  AddProductViewmodel model;
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              ProxyService.nav.navigateTo(Routing.addCategoryScreen);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.3),
              leading: const Text('Category'),
              trailing: Wrap(
                children: <Widget>[
                  CategorySelector(
                    categories: model.state.categories,
                  ),
                  Theme(
                    data: ThemeData(
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                    ),
                    child: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
