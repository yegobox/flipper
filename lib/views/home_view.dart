import 'package:flipper/views/flipper_drawer.dart';
import 'package:flipper/views/home_app_bar.dart';
import 'package:pos/pos.dart';
import 'package:flipper/views/product/product_view.dart';

import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/widget/bottom_menu_bar.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:pos/pos_viewmodel.dart';
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
  // ignore!
  // ignore: missing_return
  Widget _getPage(
      {@required int index,
      @required CommonViewModel vm,
      @required PosViewModel model}) {
    switch (index) {
      case 0:
        // return KeyPadView();
        return KeyPad(model: model);
        break;
      case 1:
        return ProductView(userId: vm.user.id, items: true);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, HomeViewModel model, Widget child) {
          return Scaffold(
            extendBody: true,
            key: _scaffoldKey,
            appBar: HomeAppBar(
              scaffoldKey: _scaffoldKey,
              sideOpenController: sideOpenController,
            ),
            bottomNavigationBar: BottomMenubar(
              model: model,
            ),
            body: ViewModelBuilder<PosViewModel>.reactive(
              builder: (BuildContext context, PosViewModel pos, Widget child) {
                return Column(
                  children: <Widget>[
                    model.tab == 1
                        ? Display(model: pos)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: Container(
                        child: SafeArea(
                          child: Container(
                            child:
                                _getPage(index: model.tab, vm: vm, model: pos),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              viewModelBuilder: () => PosViewModel(),
            ),
            drawer: FlipperDrawer(),
          );
        },
        onModelReady: (HomeViewModel model) {
          model.initTab();
        },
        viewModelBuilder: () => HomeViewModel());
  }
}
