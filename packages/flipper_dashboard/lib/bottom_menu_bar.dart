import 'package:flutter/material.dart';

import 'custom_widgets.dart';

const int ANIM_DURATION = 300;
const double ICON_OFF = -3;
const double ICON_ON = 0;
const double ALPHA_ON = 1;

class BottomMenubar extends StatefulWidget {
  BottomMenubar({Key? key, required this.switchTab}) : super(key: key);

  final Function switchTab;
  @override
  _BottomMenubarState createState() => _BottomMenubarState();
}

class _BottomMenubarState extends State<BottomMenubar> {
  int tab = 0;
  Widget _iconRow() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor,
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0)
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: _icon(
              null,
              tab == 0 ? true : false,
              0,
              icon: tab == 0
                  ? const Image(
                      width: 28,
                      height: 25,
                      image: AssetImage('assets/icons/keypad_enable.png'))
                  : const Image(
                      width: 28,
                      height: 25,
                      image: AssetImage('assets/icons/keypad_disable.png')),
              isCustomIcon: true,
              text: 'Keypad',
            ),
          ),
          Container(
            child: _icon(
              null,
              tab == 1 ? true : false,
              1,
              icon: tab == 1
                  ? const Image(
                      width: 28,
                      height: 25,
                      image: AssetImage('assets/icons/library_enable.png'))
                  : const Image(
                      width: 28,
                      height: 25,
                      image: AssetImage('assets/icons/library_disable.png')),
              isCustomIcon: true,
              text: 'Library',
            ),
          )
        ],
      ),
    );
  }

  Widget _icon(IconData? iconData, bool focus, int index,
      {bool isCustomIcon = false,
      bool message = false,
      Image? icon,
      String? text}) {
    return Expanded(
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
            // alignment: const Alignment(0, 0),
            icon: isCustomIcon
                ? customBottomIcon(
                    context,
                    icon: icon,
                    size: 20,
                    istwitterIcon: true,
                    isEnable: focus,
                    text: text!,
                  )
                : message
                    ? Icon(
                        Icons.home_filled,
                        color: focus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.caption!.color,
                      )
                    : Icon(
                        iconData,
                        color: focus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.caption!.color,
                      ),
            onPressed: () {
              setState(() {
                tab = index;
              });
              widget.switchTab(index);
            },
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
