import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/models.dart';
import 'package:stacked/stacked.dart';
import 'divider.dart';
import 'package:go_router/go_router.dart';

class ListCategories extends StatelessWidget {
  const ListCategories({Key? key, required this.categories}) : super(key: key);
  final List<Category> categories;
  Wrap CategoryList(
      {required List<Category> categories,
      required BuildContext context,
      required ProductViewModel model}) {
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
                trailing: Radio<int>(
                  value: categories[i].id,
                  activeColor: Theme.of(context)
                      .copyWith(canvasColor: HexColor('#2996CC'))
                      .canvasColor,
                  //This radio button is considered selected if its value matches the groupValue.
                  groupValue:
                      categories[i].focused == true ? categories[i].id : 0,
                  onChanged: (value) {
                    model.updateCategory(category: categories[i]);
                  },
                ),
              ),
            ),
          ),
        );
      }
      list.add(const Center(
        child: SizedBox(
          width: double.infinity,
          child: CenterDivider(
            width: double.infinity,
          ),
        ),
      ));
    }
    return Wrap(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                GoRouter.of(context).pop();
              },
              showActionButton: false,
              title: 'Category',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView(
              children: <Widget>[
                const Center(
                  child: CenterDivider(
                    width: double.infinity,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(Routes.category);
                  },
                  child: ListTile(
                    title: const Text('Create Category ',
                        style: TextStyle(color: Colors.black)),
                    trailing: Wrap(
                      children: const <Widget>[
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                CategoryList(
                  categories: model.categories,
                  context: context,
                  model: model,
                ),
              ],
            ),
          );
        });
  }
}
