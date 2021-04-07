import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/view_models/add_product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
    this.categories,
  }) : super(key: key);

  final List<Category> categories;

  Wrap _getCategoriesWidgets(
    List<Category> categories,
    AddProductViewmodel model,
    BuildContext context,
  ) {
    final List<Widget> list = <Widget>[];
    if (categories == null) {
      list.add(const SizedBox.shrink());
      return Wrap(children: list);
    }
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
    return ViewModelBuilder<AddProductViewmodel>.reactive(
      viewModelBuilder: () => AddProductViewmodel(),
      onModelReady: (AddProductViewmodel model) => model.getCategories(),
      builder: (BuildContext context, AddProductViewmodel model, Widget child) {
        return _getCategoriesWidgets(categories, model, context);
      },
    );
  }
}
