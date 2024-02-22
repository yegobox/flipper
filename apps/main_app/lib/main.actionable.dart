import 'package:flipper_actionable/actionable.dart' show Actionable, hexToColor;
// import 'package:flipper_actionable/locator.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  List<Widget> widgets = [];

  for (var i = 0; i < 2; i++) {
    widgets.add(
      Container(
        color: hexToColor('F7F7F7'),
        height: 81.4,
        child: ListTile(
          title: const Padding(
            padding: EdgeInsets.only(top: 19.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text("Banana"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text("200 items"),
                ),
              ],
            ),
          ),
          leading: Container(
            width: 74.78,
            height: 81.4,
            color: const Color(0xff07fe21),
            child: const Center(
              child: Text(
                "B",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          trailing: const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text("4500"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text("90,000"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  runApp(MaterialApp(
    home: Actionable(
      spaceOnTop: 20,
      showActionalView: true,
      withRadius: 20.0,
      backView: Container(
        color: Colors.blue,
      ),
      widgets: widgets,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
// The bellow command were used to activate flutterfire_cli very good to use.
// dart global activate flutterfire_cli