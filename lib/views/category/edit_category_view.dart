import 'package:customappbar/customappbar.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/view_models/category_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

enum CategoriesEnum { beverage, drinks, ikawa }

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({Key key, @required this.productId})
      : super(key: key);
  final String productId;

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  Wrap _getCategoriesWidgets(List<Category> categories) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].focused) {
        updateItemWithActiveCategory(categories, i);
      }
      if (categories[i].name != 'custom') {
        list.add(
          GestureDetector(
            onTap: () {
              // FIXME:
              print('unkozeho');
              for (int y = 0; y < categories.length; y++) {
                print(categories[i].name);
                // vm.database.categoryDao
                //     .updateCategory(categories[y].copyWith(focused: false));
              }
              // FIXME:
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
                groupValue: categories[i].focused ? categories[i].id : 0,
                onChanged: (Object value) {},
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

  // ignore: always_specify_types
  Future updateItemWithActiveCategory(List<Category> categories, int i) async {
    // final DialogService _dialogService = ProxyService.modal;
    // _dialogService.showConfirmationDialog(
    //     description: 'Can not update active product feature deprecated');
    // final item = await vm.database.productDao.getItemById(productId: widget.ItemId);
    // if (item != null) {
    //   vm.database.productDao
    //       .updateItem(item.copyWith(categoryId: categories[i].id));
    // }
  }
  category_list.dar
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CategoryViewModel(),
        builder: (BuildContext context, CategoryViewModel model, Widget child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              showActionButton: false,
              title: S.of(context).editCategory,
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Wrap(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 400,
                    child: const Divider(
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ProxyService.nav
                        .navigateTo(Routing.createCategoryInputScreen);
                  },
                  child: ListTile(
                    title: const Text('Create Categorykk',
                        style: TextStyle(color: Colors.black)),
                    trailing: Wrap(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[const Icon(Icons.arrow_forward_ios)],
                    ),
                  ),
                ),
                _getCategoriesWidgets(model.categories)
              ],
            ),
          );
        });
  }
}
