import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_routing/routes.router.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key? key, required this.categories})
      : super(key: key);
  final List<Category> categories;

  Widget categorySelector(
      {required List<Category> categories, required BuildContext context}) {
    late Text text;
    if (categories.isEmpty) {
      return const Text('Select Category');
    }
    for (Category category in categories) {
      if (category.focused) {
        text = Text(
          category.name,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
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
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push(Routes.categories, extra: categories);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.3),
              leading: const Text('Category'),
              trailing: Wrap(
                children: <Widget>[
                  categorySelector(categories: categories, context: context),
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
  }
}
