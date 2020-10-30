import 'package:flipper/ui/flipper_drawer.dart';
import 'package:flipper/ui/home_app_bar.dart';
import 'package:flipper/ui/keypad/poswidget.dart';
import 'package:flipper/ui/product/product_screen.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/ui/welcome/payable/payable_view.dart';

import 'package:flipper/ui/widget/bottom_menu_bar.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<bool> sideOpenController;
  final CommonViewModel vm;
  final bool showAppBar;

  // ignore: sort_constructors_first
  const HomeScreen({
    Key key,
    @required this.sideOpenController,
    this.showAppBar = false,
    this.vm,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: missing_return
  Widget _getPage({@required int index,@required CommonViewModel vm}) {
    switch (index) {
      case 0:
        return const Poswidget();
        // return const ProductScreen();
        break;
      case 1:
        return  ProductScreen(userId: vm.user.id,);
        break;
      case 2:
        return  ProductScreen(userId: vm.user.id,);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, HomeViewModel model, Widget child) {
          return Scaffold(
            extendBody: true,
            key: _scaffoldKey,
            appBar: HomeAppBar(
              scaffoldKey: _scaffoldKey,
              sideOpenController: widget.sideOpenController,
            ),
            bottomNavigationBar: BottomMenubar(
              model: model,
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: PayableView(),
                ),
                Expanded(
                  child: Container(
                    child: SafeArea(
                      child: Container(
                        child: _getPage(index:model.tab,vm: widget.vm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer: FlipperDrawer(
              vm: widget.vm,
            ),
          );
        },
        onModelReady: (HomeViewModel model) {
          model.initTab();
        },
        viewModelBuilder: () => HomeViewModel());
  }
}
