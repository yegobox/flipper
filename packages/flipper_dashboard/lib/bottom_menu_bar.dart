import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({Key? key, required this.switchTab, this.index = 0})
      : super(key: key);
  final Function switchTab;
  final int index;
  // TODOfix the focusing on a tab when clicked. later.
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value) {
        switchTab(value);
      },
      items: [
        BottomNavigationBarItem(
          activeIcon: Image(
            width: 28.w,
            height: 25.h,
            image: AssetImage(
              'assets/icons/keypad_enable.png',
            ),
          ),
          icon: Image(
            width: 28.w,
            height: 25.h,
            image: AssetImage(
              'assets/icons/keypad_disable.png',
            ),
          ),
          label: 'Keypad',
        ),
        BottomNavigationBarItem(
          activeIcon: Image(
            width: 28.w,
            height: 25.h,
            image: AssetImage(
              'assets/icons/library_enable.png',
            ),
          ),
          icon: Image(
            width: 28.w,
            height: 25.h,
            image: AssetImage(
              'assets/icons/library_disable.png',
            ),
          ),
          label: 'Library',
        ),
      ],
    );
  }
}
