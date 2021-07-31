import 'package:flipper_chat/lite/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  Tabs({
    Key? key,
    required this.listBtnTabs,
    this.color = Colors.white,
    this.height = kToolbarHeight,
  }) : super(key: key);

  final List<BtnTab> listBtnTabs;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      child: Row(children: listBtnTabs),
    );
  }
}

class BtnTab extends StatelessWidget {
  const BtnTab({
    Key? key,
    required this.text,
    required this.ontap,
    this.status = false,
    this.notications = 0,
  }) : super(key: key);

  final String text;
  final VoidCallback ontap;
  final bool status;
  final int notications;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoButton(
                child: FittedBox(
                  child: Text(
                    text,
                    style: status
                        ? Helpers.txtDefault.copyWith(
                            color: Colors.white,
                          )
                        : Helpers.txtDefault,
                  ),
                ),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(50),
                minSize: 0,
                color: status ? Helpers.greenColor : Colors.white,
                onPressed: ontap,
              ),
            ),
          ),
          notications == 0
              ? const SizedBox.shrink()
              : Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Helpers.greenColor,
                      border: Border.all(color: Colors.white, width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        '$notications',
                        style: Helpers.txtBtnTabsNotifications,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
