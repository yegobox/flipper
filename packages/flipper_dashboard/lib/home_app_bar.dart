import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar(
      {Key? key,
      required this.scaffoldKey,
      required this.sideOpenController,
      this.child})
      : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueNotifier<bool> sideOpenController;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        leading: _hamburger(),
        title: child == null ? SizedBox.shrink() : child,
      ),
    );
  }

  Widget _hamburger() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          scaffoldKey.currentState!.openDrawer();
        },
        child: Container(
          width: 44.0,
          height: 44.0,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Image.asset(
                  'assets/icons/menu_icon.png',
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
  Size get preferredSize => const Size.fromHeight(44.0);
}
