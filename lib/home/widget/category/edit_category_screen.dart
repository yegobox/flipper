import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/managers/dialog_manager.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

enum CategoriesEnum { beverage, drinks, ikawa }

class EditCategoryScreen extends StatefulWidget {
  EditCategoryScreen({Key key, @required this.productId}) : super(key: key);
  final String productId;

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  _getCategoriesWidgets(
      List<CategoryTableData> categories, CommonViewModel vm) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < categories.length; i++) {
      if (categories[i].focused) {
        updateItemWithActiveCategory(vm, categories, i);
      }
      if (categories[i].name != "custom") {
        list.add(
          GestureDetector(
            onTap: () {
              for (var y = 0; y < categories.length; y++) {
                vm.database.categoryDao
                    .updateCategory(categories[y].copyWith(focused: false));
              }
              //
              vm.database.categoryDao.updateCategory(
                  categories[i].copyWith(focused: !categories[i].focused));
            },
            child: ListTile(
              title: Text(
                categories[i].name,
                style: TextStyle(color: Colors.black),
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
          child: Divider(
            color: Colors.black,
          ),
        ),
      ));
    }
    return Wrap(children: list);
  }

  Future updateItemWithActiveCategory(
      CommonViewModel vm, List<CategoryTableData> categories, int i) async {
    Manager.deprecatedNotification();
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
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Router.navigator.pop();
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
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    CreateEmptyTempCategoryAction(name: "tmp"),
                  );
                  Router.navigator.pushNamed(Router.createCategoryInputScreen);
                },
                child: ListTile(
                  title: Text("Create Category",
                      style: TextStyle(color: Colors.black)),
                  trailing: Wrap(
                    children: <Widget>[Icon(Icons.arrow_forward_ios)],
                  ),
                ),
              ),
              StreamBuilder(
                stream: vm.database.categoryDao.getCategoriesStream(),
                builder:
                    (context, AsyncSnapshot<List<CategoryTableData>> snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return _getCategoriesWidgets(snapshot.data, vm);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
