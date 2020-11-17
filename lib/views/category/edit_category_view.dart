import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/services/proxy.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


enum CategoriesEnum { beverage, drinks, ikawa }

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({Key key, @required this.productId}) : super(key: key);
  final String productId;

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  Wrap _getCategoriesWidgets(
      List<Category> categories, CommonViewModel vm) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].focused) {
        updateItemWithActiveCategory(vm, categories, i);
      }
      if (categories[i].name != 'custom') {
        list.add(
          GestureDetector(
            onTap: () {
              // FIXME:
              for (int y = 0; y < categories.length; y++) {
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
  Future updateItemWithActiveCategory(
      CommonViewModel vm, List<Category> categories, int i) async {
    // final DialogService _dialogService = ProxyService.modal;
    // _dialogService.showConfirmationDialog(
    //     description: 'Can not update active product feature deprecated');
    // final item = await vm.database.productDao.getItemById(productId: widget.ItemId);
    // if (item != null) {
    //   vm.database.productDao
    //       .updateItem(item.copyWith(categoryId: categories[i].id));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
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
                  StoreProvider.of<AppState>(context).dispatch(
                    CreateEmptyTempCategoryAction(name: 'tmp'),
                  );
                  _navigationService
                      .navigateTo(Routing.createCategoryInputScreen);
                },
                child: ListTile(
                  title: const Text('Create Category',
                      style: TextStyle(color: Colors.black)),
                  trailing: Wrap(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[const Icon(Icons.arrow_forward_ios)],
                  ),
                ),
              ),
              // FIXME
              // StreamBuilder(
              //   stream: vm.database.categoryDao.getCategoriesStream(),
              //   builder:
              //       (BuildContext context, AsyncSnapshot<List<CategoryTableData>> snapshot) {
              //     if (snapshot.data == null) {
              //       return Container();
              //     }
              //     return _getCategoriesWidgets(snapshot.data, vm);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
