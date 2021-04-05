import 'package:flutter/material.dart';
import 'file:///E:/demos/flipper/packages/flipper_models/lib/view_models/category_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:customappbar/customappbar.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/widget/category_list.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';

class AddCategoryView extends StatelessWidget {
  const AddCategoryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CategoryViewModel(),
        onModelReady: (CategoryViewModel model) {
          model.getCategory();
        },
        builder: (BuildContext context, CategoryViewModel model, Widget child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              showActionButton: false,
              title: 'Category',
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
                    title: const Text('Create Category ',
                        style: TextStyle(color: Colors.black)),
                    trailing: Wrap(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                CategoryList(
                  categories: model.categories,
                ),
              ],
            ),
          );
        });
  }
}
