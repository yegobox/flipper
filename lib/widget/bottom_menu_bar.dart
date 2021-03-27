import 'package:flipper/widget/custom_widgets.dart';
import 'package:flipper/widget/tabItem.dart';

import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/pos_viewmodel.dart';

class BottomMenubar extends StatefulWidget {
  const BottomMenubar({this.model});

  final PosViewModel model;

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
      //margin: EdgeInsets.only(: 10,right: 10),
      decoration: BoxDecoration(color: Theme.of(context).bottomAppBarColor,
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0)
          ]),
      child:
          //Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          //  crossAxisAlignment: CrossAxisAlignment.center,
          // children: [
          // Container(
          //   padding: EdgeInsets.all(10),
          //   margin: const EdgeInsets.symmetric(horizontal: 10.0),
          //   decoration: BoxDecoration(
          //     color: Colors.green,
          //     borderRadius: BorderRadius.all(Radius.circular(50)),
          //   ),
          //   child: GestureDetector(
          //     onTap: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AddProductModal(
          //             userId: "userId",
          //           );
          //         },
          //       );
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         new Icon(Icons.add,
          //             size: 20,
          //             // These colors are not defined in the Material Design spec.
          //             color: Colors.white),
          //         Text(" Add Product",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.white))
          //       ],
          //     ),
          //   ),
          // ),
          Row(
        // Icons.ac_unit
        //mainAxisSize: MainAxisSize.max,
        //crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //alignment: Alignment.centerLeft,
            //padding: EdgeInsets.only(right:10),
            child: _icon(null, widget.model.tab == 0 ? true : false, 0,
                icon: widget.model.tab == 0
                    ? const Image(
                        width: 28,
                        height: 25,
                        image: AssetImage('assets/keypad_enable.png'))
                    : const Image(
                        width: 28,
                        height: 25,
                        image: AssetImage('assets/keypad_disable.png')),
                isCustomIcon: true,
                text: 'Keypad'),
          ),
          Container(
            // alignment: Alignment.centerRight,
            child: _icon(null, widget.model.tab == 1 ? true : false, 1,
                icon: widget.model.tab == 1
                    ? const Image(
                        width: 28,
                        height: 25,
                        image: AssetImage('assets/library_enable.png'))
                    : const Image(
                        width: 28,
                        height: 25,
                        image: AssetImage('assets/library_disable.png')),
                isCustomIcon: true,
                text: 'Library'),
          ),
          // _icon(null, widget.model.tab == 2 ? true : false, 2,
          //     icon: 3 == 3 ? AppIcon.chat : AppIcon.chat,
          //     isCustomIcon: false,
          //     message: true),
          // _icon(null, widget.model.tab == 3 ? true : false, 3,
          //     icon: 4 == 4 ? AppIcon.messageFill : AppIcon.messageEmpty,
          //     isCustomIcon: true),
        ],
      ),
      // ],
      // )
    );
  }

  Widget _icon(IconData iconData, bool focus, int index,
      {bool isCustomIcon = false,
      bool message = false,
      Image icon,
      String text}) {
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
                  ? customBottomIcon(context,
                      icon: icon,
                      size: 20,
                      istwitterIcon: true,
                      isEnable: focus,
                      text: text)
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
