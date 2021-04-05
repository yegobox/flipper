import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_models/category.dart';
import 'file:///E:/demos/flipper/packages/flipper_models/lib/view_models/category_viewmodel.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
    this.categories,
  }) : super(key: key);

  final List<Category> categories;

  Wrap _getCategoriesWidgets(
    List<Category> categories,
    CategoryViewModel model,
    BuildContext context,
  ) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name != 'custom') {
        list.add(
          GestureDetector(
            onTap: () {
              model.updateCategory(category: categories[i]);
            },
            child: SingleChildScrollView(
              child: ListTile(
                title: Text(
                  categories[i].name,
                  style: const TextStyle(color: Colors.black),
                ),
                trailing: Radio(
                  value: categories[i].id,
                  activeColor: Theme.of(context)
                      .copyWith(canvasColor: HexColor('#2996CC'))
                      .canvasColor,
                  //This radio button is considered selected if its value matches the groupValue.
                  groupValue:
                      categories[i].focused == true ? categories[i].id : 0,
                  onChanged: (Object value) {},
                ),
              ),
            ),
          ),
        );
      }
      list.add(Center(
        child: Container(
          width: 400,
          child: const Divider(
            color: Colors.black,
          ),
        ),
      ));
    }
    return Wrap(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryViewModel>.reactive(
      viewModelBuilder: () => CategoryViewModel(),
      onModelReady: (CategoryViewModel model) => model.getCategory(),
      builder: (BuildContext context, CategoryViewModel model, Widget child) {
        return _getCategoriesWidgets(categories, model, context);
      },
    );
  }
}
