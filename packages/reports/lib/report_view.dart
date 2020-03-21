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
        )
        // ListView(
        //  children: ListTile.divideTiles(
        //       context: context,
        //       tiles: getProducts(widget.data, context, widget.vm),
        //     ).toList(),
        //   )
      ],
    );
  }
}
