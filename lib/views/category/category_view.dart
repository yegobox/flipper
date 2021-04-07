import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/view_models/category_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoryView extends StatelessWidget {
  Widget categorySelector({List<Category> categories, BuildContext context}) {
    Text text;
    if (categories.isEmpty) {
      return const Text('Select Category');
    }
    for (Category category in categories) {
      if (category.focused) {
        text = Text(
          category.name,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.black),
        );
        return text;
      } else {
        text = const Text('Select Category');
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder<CategoryViewModel>.reactive(
        viewModelBuilder: () => CategoryViewModel(),
        onModelReady: (CategoryViewModel model) {
          model.getCategories();
        },
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
                        categorySelector(
                            categories: model.state.categories,
                            context: context),
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
        });
  }
}
