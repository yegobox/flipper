import 'package:flutter/material.dart';

class ReportView extends StatefulWidget {
  ReportView({Key key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        ListTile(
          dense: true,
          trailing: FlatButton(
            onPressed: () {},
            child: Text("...."),
          ),
          leading: Text("SALES SUMMARY: OVERVIEW"),
          title: Text(""),
        ),
        ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: getReport(),
          ).toList(),
        )
      ],
    );
  }

  List<Widget> getReport() {
    List<Widget> list = [];

    list.add(ListTile(
      leading: Text(
        'FRw 1700',
        style: TextStyle(color: Colors.black),
      ),
      trailing: Text("FRw 1200", style: TextStyle(color: Colors.black)),
    ));
    return list;
  }
}
