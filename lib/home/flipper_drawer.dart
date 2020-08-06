import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';

import 'branch_list/branch_list.dart';
import 'business_list/business_list.dart';

enum DrawerState { CALENDAR, CHANNEL }

class FlipperDrawer extends StatefulWidget {
  final CommonViewModel vm;

  const FlipperDrawer({Key key, this.vm}) : super(key: key);
  @override
  _FlipperDrawerState createState() => _FlipperDrawerState();
}

class _FlipperDrawerState extends State<FlipperDrawer> {
  DrawerState _drawerState = DrawerState.CHANNEL;

  _drawerStateChange(DrawerState state) {
    setState(() {
      _drawerState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: HexColor('#211a36'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BusinessList(
              vm: widget.vm,
            ),
            BranchList(
              vm: widget.vm,
            )
          ],
        ),
      ),
    );
  }
}
