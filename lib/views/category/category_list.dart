import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_models/view_models/category_viewmodel.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
    this.model,
  }) : super(key: key);

  final CategoryViewModel model;

  Wrap _getCategoriesWidgets(
    CategoryViewModel model,
    BuildContext context,
  ) {
    final List<Widget> list = <Widget>[];
    if (model.categories == null) {
      list.add(const SizedBox.shrink());
      return Wrap(children: list);
    }
    for (int i = 0; i < model.categories.length; i++) {
      if (model.categories[i].name != 'custom') {
        list.add(
          GestureDetector(
            onTap: () {
              model.updateCategory(category: model.categories[i]);
            },
            child: SingleChildScrollView(
              child: ListTile(
                title: Text(
                  model.categories[i].name,
                  style: const TextStyle(color: Colors.black),
                ),
                trailing: Radio(
                  value: model.categories[i].id,
                  activeColor: Theme.of(context)
                      .copyWith(canvasColor: HexColor('#2996CC'))
                      .canvasColor,
                  //This radio button is considered selected if its value matches the groupValue.
                  groupValue: model.categories[i].focused == true
                      ? model.categories[i].id
                      : 0,
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
    return _getCategoriesWidgets(model, context);
  }
}
