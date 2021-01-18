import 'package:flipper/views/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    @required this.scaffoldKey,
    @required this.sideOpenController,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueNotifier<bool> sideOpenController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, HomeViewModel model, Widget child) {
          return SafeArea(
            top: true,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              leading: _hamburger(),
              title: Container(
                color: Theme.of(context)
                    .copyWith(canvasColor: Colors.transparent)
                    .canvasColor,
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FlatButton(
                    onPressed: null,
                    child: Text(
                      buildSaleWording(model: model),
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ),
              trailing: const SizedBox.shrink(),
            ),
          );
        },
        onModelReady: (HomeViewModel model) {
          model.currentSale();
        },
        viewModelBuilder: () => HomeViewModel());
  }

  String buildSaleWording({HomeViewModel model}) {
    if (model.sales.isEmpty) {
      return 'No Sale';
    } else {
      return 'Current Sale [ ' + model.sales.length.toString() + ' ]';
    }
  }

  Widget _hamburger() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          scaffoldKey.currentState.openDrawer();
        },
        child: Container(
          width: appBarSize,
          height: appBarSize,
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Image.asset(
                  'assets/graphics/menu_icon.png',
                  width: 25,
                  height: 25,
                ),
                Visibility(
                  visible: true,
                  child: Positioned(
                    top: -3,
                    right: -5,
                    height: 12,
                    width: 12,
                    child: ClipOval(
                      child:
                          Container(color: Colors.green, width: 12, height: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarSize);
}
