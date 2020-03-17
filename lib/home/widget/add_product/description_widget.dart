import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';

class DescriptionWidget extends StatefulWidget {
  DescriptionWidget({Key key}) : super(key: key);

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          style: TextStyle(color: Colors.black),
          decoration:
              InputDecoration(hintText: "Description", focusColor: Colors.blue),
          onChanged: (description) {
            setState(() {
              DataManager.description = description;
            });
          },
        ),
      ),
    );
  }
}
