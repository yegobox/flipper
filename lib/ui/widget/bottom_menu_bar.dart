import 'package:flipper/ui/home_viewmodel.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/ui/widget/custom_widgets.dart';
import 'package:flipper/ui/widget/tabItem.dart';
import 'package:flutter/material.dart';

class BottomMenubar extends StatefulWidget {
  const BottomMenubar({this.model});
  final HomeViewModel model;

  @override
  _BottomMenubarState createState() => _BottomMenubarState();
}

class _BottomMenubarState extends State<BottomMenubar> {
  @override
  void initState() {
    super.initState();
  }

  Widget _iconRow() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          boxShadow: [
            const BoxShadow(
                color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0)
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //state.pageIndex ==?
          _icon(null, 0,
              icon: 0 == 0 ? AppIcon.homeFill : AppIcon.home,
              isCustomIcon: true),
          _icon(null, 1,
              // icon: 1 == 1 ? AppIcon.searchFill : AppIcon.search,
              icon: 1 == 1 ? AppIcon.lists : AppIcon.lists,
              isCustomIcon: true),

          // NOTE: this was supposed to be in menu drawer
          // _icon(null, 2,
          //     icon: 2 == 2 ? AppIcon.lists : AppIcon.lists,
          //     isCustomIcon: true),
          _icon(null, 3,
              icon: 3 == 3 ? AppIcon.notificationFill : AppIcon.notification,
              isCustomIcon: true),
          _icon(null, 4,
              icon: 4 == 4 ? AppIcon.messageFill : AppIcon.messageEmpty,
              isCustomIcon: true),
        ],
      ),
    );
  }

  Widget _icon(IconData iconData, int index,
      {bool isCustomIcon = false, int icon}) {
    // ignore: always_specify_types
    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: ANIM_DURATION),
          curve: Curves.easeIn,
          alignment: const Alignment(0, ICON_ON),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: ANIM_DURATION),
            opacity: ALPHA_ON,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              alignment: const Alignment(0, 0),
              icon: isCustomIcon
                  ? customIcon(context,
                      icon: icon,
                      size: 22,
                      istwitterIcon: true,
                      isEnable: index == 1)
                  : Icon(
                      iconData,
                      color: index == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.caption.color,
                    ),
              onPressed: () {
                widget.model.switchTab(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _iconRow();
  }
}
