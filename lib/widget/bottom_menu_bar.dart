import 'package:flipper/utils/constant.dart';
import 'package:flipper/views/home_viewmodel.dart';
import 'package:flipper/widget/custom_widgets.dart';
import 'package:flipper/widget/tabItem.dart';

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
      height: 65,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          boxShadow: [
            const BoxShadow(
                color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0)
          ]),
      child: Row(
        // Icons.ac_unit
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _icon(null, widget.model.tab == 0 ? true : false, 0,
              icon: 0 == 0 ? AppIcon.homeFill : AppIcon.home,
              isCustomIcon: true,text: "Keypad"),
          _icon(null, widget.model.tab == 1 ? true : false, 1,
              icon: 1 == 1 ? AppIcon.lists : AppIcon.lists, isCustomIcon: true,text: "Library"),
          // _icon(null, widget.model.tab == 2 ? true : false, 2,
          //     icon: 3 == 3 ? AppIcon.chat : AppIcon.chat,
          //     isCustomIcon: false,
          //     message: true),
          // _icon(null, widget.model.tab == 3 ? true : false, 3,
          //     icon: 4 == 4 ? AppIcon.messageFill : AppIcon.messageEmpty,
          //     isCustomIcon: true),
        ],
      ),
    );
  }

  Widget _icon(IconData iconData, bool focus, int index,
      {bool isCustomIcon = false, bool message = false, int icon, String text}) {
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
                      isEnable: focus,text:text)
                  : message
                      ? Icon(
                          Icons.home_filled,
                          color: focus
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.caption.color,
                        )
                      : Icon(
                          iconData,
                          color: focus
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
