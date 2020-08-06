import 'package:flipper/home/reports/bar_chart.dart';
import 'package:flipper/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportView extends StatefulWidget {
  ReportView({Key key, this.netProfit, this.grossProfit}) : super(key: key);

  final double netProfit;
  final double grossProfit;

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
        Expanded(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: getReport(),
            ).toList(),
          ),
        ),
        BarChartReport()
      ],
    );
  }

  List<Widget> getReport() {
    List<Widget> list = [];
    //header
    list.add(ListTile(
      dense: true,
      trailing: FlatButton(
        onPressed: () {},
        child: IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ),
      leading: Wrap(
        children: <Widget>[
          Text(
            'SALES SUMMARY',
          ),
          SizedBox(
            width: 2,
          ),
          Text(':'),
          SizedBox(
            width: 2,
          ),
          Text('OVERVIEW')
        ],
      ),
      // title: Text('he'),
    ));

    list.add(ListTile(
      leading: Column(
        children: <Widget>[
          Text(
            'FRw ' + widget.grossProfit.toString(),
            style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              color: AppTheme.addProduct.accentColor,
              fontSize: AppTheme.addProduct.textTheme.bodyText1.fontSize,
            ),
          ),
          Text('Gross profit')
        ],
      ),
      trailing: Column(
        children: <Widget>[
          Text(
            'FRw ' + widget.netProfit.toString(),
            style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              color: AppTheme.addProduct.accentColor,
              fontSize: AppTheme.addProduct.textTheme.bodyText1.fontSize,
            ),
          ),
          Text('Net profit')
        ],
      ),
    ));

    //summary of report and chart to follow.
    list.add(
      ListTile(
        dense: true,
        trailing: FlatButton(
          onPressed: () {},
          child: IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ),
        leading: Wrap(
          children: <Widget>[
            Text(
              'Gross SALES',
            )
          ],
        ),
        // title: Text('he'),
      ),
    );

    //month,date year
    final today = DateTime.now();
    final month = getMonthString(today);
    final todayDay = DateTime.now().day;
    final year = DateTime.now().year;
    list.add(
      Container(
        margin: EdgeInsets.only(
          top: 0,
          left: 20,
        ),
        child: Text(
          '$month $todayDay,$year',
          style: GoogleFonts.lato(
            fontStyle: FontStyle.normal,
            color: AppTheme.addProduct.accentColor,
            fontSize: AppTheme.addProduct.textTheme.bodyText1.fontSize,
          ),
        ),
      ),
    );
    list.add(
      Container(
        margin: EdgeInsets.only(
          top: 5,
          left: 20,
        ),
        child: Text(
          'FRw ' + widget.grossProfit.toString(),
          style: GoogleFonts.lato(
            fontStyle: FontStyle.normal,
            color: AppTheme.addProduct.accentColor,
            fontSize: AppTheme.addProduct.textTheme.bodyText1.fontSize,
          ),
        ),
      ),
    );
    return list;
  }

  String getMonthString(DateTime tm) {
    //todo: should think of how to show this graph need more clear idea...
    switch (tm.month) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
      default:
        return '';
    }
  }
}
