import 'package:flipper/views/home_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    @required this.scaffoldKey,
    @required this.sideOpenController,
    this.model,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueNotifier<bool> sideOpenController;
  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
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
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(children: <Widget>[
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      // ProxyService.nav.navigateTo(Routing.completeSaleView);
                      // TODO: implements detail page
                    },
                    child: buildSaleWording(model: model, context: context)),
              ),
              GestureDetector(
                onTap: () async {
                  final bool loggedOut = ProxyService.sharedPref.logout();
                  if (loggedOut) {
                    ProxyService.database.logout(context: context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Log Out',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontSize: 15,
                        color: const Color(0xff363f47),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ]),
          ),
        ),
        // trailing: const SizedBox.shrink(),
      ),
    );
  }

  Widget buildSaleWording({HomeViewModel model, BuildContext context}) {
    if (model.tab == 0 || model.tab == 1) {
      if (model.currentSale.isEmpty) {
        return Text('No Sale',
            style: Theme.of(context).textTheme.headline4.copyWith(
                fontSize: 16,
                color: const Color(0xff363f47),
                fontWeight: FontWeight.w600));
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Sale'),
            Stack(
              alignment: AlignmentDirectional.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(model.currentSale.length.toString()),
                const IconButton(
                  icon: FaIcon(FontAwesomeIcons.clone),
                  onPressed: null,
                ),
              ],
            ),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
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
                      child: Container(
                          color: const Color(0xff2996cc),
                          width: 12,
                          height: 12),
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
