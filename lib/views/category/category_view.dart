import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/category/category_selecter_view.dart';
import 'package:flipper_models/view_models/category_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, CategoryViewModel model, Widget child) {
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
                        model.categories == null
                            ? const Text('Select Category')
                            : CategorySelector(
                                categories: model.categories,
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
        },
        onModelReady: (CategoryViewModel model) {
          model.getCategories();
        },
        viewModelBuilder: () => CategoryViewModel());
  }
}
