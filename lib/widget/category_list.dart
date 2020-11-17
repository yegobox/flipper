

import 'package:flipper/viewmodels/main_viewmodel.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
    this.vm,
  }) : super(key: key);

  final CommonViewModel vm;

  Wrap _getCategoriesWidgets(List<dynamic> categories, CommonViewModel vm) {
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
              // ignore: always_specify_types
              // ignore: missing_required_param
              trailing: Radio(
                value: categories[i].id,
                groupValue: categories[i].focused ? categories[i].id : 0,
                // onChanged: (int categoryId) {},
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
          if (model.busy || model.data == null) {
            return const SizedBox.shrink();
          }
          return Text('hello');
          // return _getCategoriesWidgets(model.data, vm);
        });
  }
}
