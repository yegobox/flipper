import 'package:flipper/ui/category/category_viewmodel.dart';
import 'package:flipper/ui/widget/category/category_selecter_view.dart';
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
            child: Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  model.navigateTo(path: 'addCategoryScreen');
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.3),
                  leading: const Text('Category'),
                  trailing: Wrap(
                    children: <Widget>[
                      model.data == null
                          ? const Text('Select Category')
                          : CategorySelector(
                              categories: model.data,
                            ),
                      Theme(
                          data: ThemeData(
                              iconTheme: const IconThemeData(
                            color: Colors.black,
                          )),
                          child: const Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => CategoryViewModel());
  }
}
