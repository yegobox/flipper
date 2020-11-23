import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key key, this.categories}) : super(key: key);
  final List<Category> categories;

  Widget categorySelector({List<Category> categories, BuildContext context}) {
    Text text;
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }
    for (Category category in categories) {
      if (category.focused && category.name!='NONE') {
        text = Text(category.name);
        StoreProvider.of<AppState>(context).dispatch(
          CategoryAction(
            category: category,
          ),
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
    return categorySelector(categories: categories, context: context);
  }
}
