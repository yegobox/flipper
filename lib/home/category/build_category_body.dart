import 'package:flipper/home/widget/category/category_selecter.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'category_viewmodel.dart';

class BuildCategoryBody extends StatelessWidget {
  const BuildCategoryBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, CategoryViewModel model, Widget child) {
          return Padding(
            padding: const EdgeInsets.only(left:18,right:18),
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
                      Theme(data:ThemeData(iconTheme: const IconThemeData(color: Colors.black,)) ,child: const Icon(Icons.arrow_forward_ios))
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
