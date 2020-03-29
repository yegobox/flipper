import 'package:flipper/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportView extends StatefulWidget {
  ReportView({Key key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        ListTile(
          dense: true,
          trailing: FlatButton(
            onPressed: () {},
            child: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          leading: Row(
            children: <Widget>[
              Text(
                "SALES SUMMARY",
              ),
              SizedBox(
                width: 2,
              ),
              Text(":"),
              SizedBox(
                width: 2,
              ),
              Text("OVERVIEW")
            ],
          ),
          title: Text(""),
        ),
        Expanded(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: getReport(),
            ).toList(),
          ),
        )
      ],
    );
  }

  List<Widget> getReport() {
    List<Widget> list = [];

    list.add(ListTile(
      leading: Column(
        children: <Widget>[
          Text(
            'FRw 1700',
            style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              color: AppTheme.addProduct.accentColor,
              fontSize: AppTheme.addProduct.textTheme.bodyText1.fontSize,
            ),
          ),
          Text("Gross profit")
        ],
      ),
      trailing: Column(
        children: <Widget>[
          Text(
            "FRw 1200",
            style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              color: AppTheme.addProduct.accentColor,
              fontSize: AppTheme.addProduct.textTheme.bodyText1.fontSize,
            ),
          ),
          Text("Net profit")
        ],
      ),
    ));
    return list;
  }
}
