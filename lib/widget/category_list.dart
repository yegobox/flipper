import 'package:flipper/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/model/category.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
    this.categories,
  }) : super(key: key);

  final List<Category> categories;

  Wrap _getCategoriesWidgets(List<Category> categories, BuildContext context) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name != 'custom') {
        list.add(
          GestureDetector(
            onTap: () {
              for (int y = 0; y < categories.length; y++) {
                // vm.database.categoryDao
                //     .updateCategory(categories[y].copyWith(focused: false));
              }
              // vm.database.categoryDao.updateCategory(
              //     categories[i].copyWith(focused: !categories[i].focused));
            },
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
                toggleable: true,
                autofocus: true,
                groupValue: categories[i].focused ? categories[i].id : 0,
                onChanged: (Object value) {},
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
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      onModelReady: (MainViewModel model) => model.listenCategory(),
      builder: (BuildContext context, MainViewModel model, Widget child) {
        return _getCategoriesWidgets(categories, context);
      },
    );
  }
}
