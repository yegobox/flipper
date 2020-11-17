import 'package:flipper/ui/flipper_drawer.dart';
import 'package:flipper/ui/home_app_bar.dart';
import 'package:flipper/ui/keypad/poswidget.dart';

import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/ui/welcome/payable/payable_view.dart';

import 'package:flipper/ui/widget/bottom_menu_bar.dart';
import 'package:flipper/ui/widget/products_edits/product_view.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  final ValueNotifier<bool> sideOpenController;
  final CommonViewModel vm;
  final bool showAppBar;

  // ignore: sort_constructors_first
   HomeView({
    Key key,
    @required this.sideOpenController,
    this.showAppBar = false,
    this.vm,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: missing_return
  Widget _getPage({@required int index, @required CommonViewModel vm}) {
    switch (index) {
      case 0:
        return const Poswidget();
        break;
      case 1:
        // return ProductsView(
        //   userId: vm.user.id,
        // );
        return ProductView(userId:vm.user.id,items:true);
        break;
    }
  }

  bool itemstab = false;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, HomeViewModel model, Widget child) {
          if (model.items == 2) {
            itemstab = true;
          }
          return Scaffold(
            extendBody: true,
            key: _scaffoldKey,
            appBar: HomeAppBar(
              scaffoldKey: _scaffoldKey,
              sideOpenController: sideOpenController,
              tabs: itemstab,
            ),
            bottomNavigationBar: BottomMenubar(
              model: model,
            ),
            body: Column(
              children: <Widget>[
                model.items == 2
                    ? const Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: SizedBox.shrink()
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: PayableView(),
                      ),
                Expanded(
                  child: Container(
                    child: SafeArea(
                      child: Container(
                        child: _getPage(index: model.tab, vm: vm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer: FlipperDrawer(
              vm: vm,
            ),
          );
        },
        onModelReady: (HomeViewModel model) {
          model.initTab();
        },
        viewModelBuilder: () => HomeViewModel());
  }
}
