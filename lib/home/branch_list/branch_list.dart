import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BranchList extends StatefulWidget {
  final CommonViewModel vm;
  BranchList({Key key, this.vm}) : super(key: key);

  @override
  _BranchListState createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  String _value;

  // ignore: non_constant_identifier_names
  DropdownButton _BranchItem() => DropdownButton<String>(
        isDense: true,
        hint: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            widget.vm.hint.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        items: widget.vm.branches.map((b) {
          return DropdownMenuItem(
            value: b.id.toString(),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/graphics/arrow-up-right.svg",
                  allowDrawingOutsideViewBox: true,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  b.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        value: _value,
        isExpanded: true,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 237,
        child: Center(
          child: Wrap(
            children: <Widget>[
              Container(
                height: 46,
              ),
              _BranchItem(),
              // ListTile(
              //   leading: SvgPicture.asset(
              //     "assets/graphics/analytics.svg",
              //     semanticsLabel: 'Analytics',
              //   ),
              //   title: Text(
              //     "Analytics",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontFamily: _Style.fontFamily,
              //         fontSize: 18),
              //   ),
              //   dense: true,
              // ),
              ListTile(
                leading: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                dense: true,
              ),
              ListTile(
                leading: FlatButton(
                  onPressed: () {
                    Router.navigator.pushNamed(Router.reportScreen);
                  },
                  child: Text(
                    "Report",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                dense: true,
              ),
              ListTile(
                leading: FlatButton(
                  onPressed: () {
                    Router.navigator.pushNamed(Router.allItemScreen);
                  },
                  child: Text(
                    "Items",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                dense: true,
              ),
              ListTile(
                leading: FlatButton(
                  onPressed: () {
                    Router.navigator.pushNamed(Router.transactionScreen);
                  },
                  child: Text(
                    "Transactions",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                dense: true,
              ),
              // ListTile(
              //   leading: SvgPicture.asset(
              //     "assets/graphics/grid.svg",
              //     semanticsLabel: 'Inventory',
              //   ),
              //   title: Text(
              //     "Inventory",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontFamily: _Style.fontFamily,
              //         fontSize: 18),
              //   ),
              //   dense: true,
              // ),
              // ListTile(
              //   leading: SvgPicture.asset(
              //     "assets/graphics/navigation.svg",
              //     semanticsLabel: 'Inventory Count',
              //   ),
              //   title: Text(
              //     "Inventory Count",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontFamily: _Style.fontFamily,
              //         fontSize: 18),
              //   ),
              //   dense: true,
              // ),
              // ListTile(
              //   leading: SvgPicture.asset(
              //     "assets/graphics/refresh.svg",
              //     semanticsLabel: 'Orders',
              //   ),
              //   title: Text(
              //     "Orders",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontFamily: _Style.fontFamily,
              //         fontSize: 18),
              //   ),
              //   dense: true,
              // ),
              SizedBox(
                height: 445,
              ),
              Container(
                width: 237,
                height: 70,
                color: HexColor("#3f3f44"),
                child: ListTile(
                  leading: SvgPicture.asset(
                    "assets/graphics/settings.svg",
                    semanticsLabel: 'Checkout',
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: _Style.fontFamily,
                        fontSize: 18),
                  ),
                  dense: true,
                ),
              )
            ],
          ),
        ));
  }
}

class _Style {
  static const fontFamily = "Heboo-Regular";
}
