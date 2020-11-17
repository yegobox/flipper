import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/widget/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


enum CategoriesEnum { beverage, drinks, ikawa }

class AddCategoryView extends StatefulWidget {
  const AddCategoryView({Key key}) : super(key: key);

  @override
  _AddCategoryViewState createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Scaffold(
          appBar: CommonAppBar(
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
                  // on navigation create a temporal category to update later
                  vm.createTempCategory(store:StoreProvider.of<AppState>(context), name:'tmp');

                  ProxyService.nav.pop();
                },
                child: ListTile(
                  title: const Text('Create Category',
                      style: TextStyle(color: Colors.black)),
                  trailing: Wrap(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              // ignore: always_specify_types
              CategoryList(
                vm: vm,
              ),
            ],
          ),
        );
      },
    );
  }
}
