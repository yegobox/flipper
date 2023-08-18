import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'custom_widgets.dart';

ListTile menuListRowButton(String title,
    {Function? onPressed,
    IconData? icon,
    bool isEnable = true,
    required BuildContext context}) {
  return ListTile(
    onTap: () {
      if (onPressed != null) {
        onPressed();
      }
    },
    title: icon == Ionicons.chatbox
        ? Stack(
            children: [
              IconButton(
                icon: Icon(icon ?? Icons.settings),
                tooltip: 'Chat',
                onPressed: () {
                  onPressed!();
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : IconButton(
            icon: Icon(icon ?? Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              onPressed!();
            },
          ),
    leading: customText(
      //was title when leading was not commented out.
      title,
      style: TextStyle(
        fontSize: 20,
        color: isEnable
            ? Theme.of(context).copyWith(canvasColor: Colors.black).canvasColor
            : Theme.of(context)
                .copyWith(canvasColor: const Color(0xffe2e8ea))
                .canvasColor,
      ),
      context: context,
    ),
  );
}
