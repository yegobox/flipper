import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/report.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class Tabs extends StatefulWidget {
  const Tabs(
      {Key key,
      @required this.tabLength,
      @required this.tabController,
      @required this.store})
      : super(key: key);

  final double tabLength;
  final TabController tabController;
  final Store<AppState> store;

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  double _grossProfit;

  double _netProfit;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.black,
      controller: widget.tabController,
      onTap: (value) async {
        //switch tab and get data and emit them.
        switch (value) {
          case 0: //i.e: 1D
            await buildReport(filter: '1D');
            break;
          case 1: //i.e: 1W
            await buildReport(filter: '1W');
            break;
          case 2: //i.e: 1M
            await buildReport(filter: '1M');
            break;
          case 3: //i.e 3M
            await buildReport(filter: '3M');
            break;
          case 4: //i.e 1Y
            await buildReport(filter: '1Y');
            break;
          default:
        }
      },
      isScrollable: true,
      tabs: [
        Container(
          width: widget.tabLength,
          child: Tab(
            text: '1D',
          ),
        ),
        Container(
          width: widget.tabLength,
          child: Tab(
            text: '1W',
          ),
        ),
        Container(
          width: widget.tabLength,
          child: Tab(
            text: '1M',
          ),
        ),
        Container(
          width: widget.tabLength,
          child: Tab(
            text: '3M',
          ),
        ),
        Container(
          width: widget.tabLength,
          child: Tab(
            text: '1Y',
          ),
        ),
      ],
    );
  }

  Future buildReport({String filter}) async {
    // FIXME:
    // List<OrderDetailTableData> report = await widget
    //     .store.state.database.stockDao
    //     .getReport(dateFilter: filter);
    // double cost = 0;
    // for (var i = 0; i < report.length; i++) {
    //   //load retail and sum them
    //   if (report[i].productName != 'custom-product') {
    //     //i.e custom sell does not have stock at hand.
    //     StockTableData stock = await widget.store.state.database.stockDao
    //         .getStockByVariantId(
    //             variantId: report[i].variationId,
    //             branchId: widget.store.state.branch.id);

    //     cost += stock.retailPrice;
    //   }
    // }
    // _grossProfit = report.fold(0, (a, b) => a + (b.subTotal));
    // _netProfit = _grossProfit - cost;

    widget.store.dispatch(ReportAction(
        report: Report((report) => report
          ..grossProfit = _grossProfit
          ..netProfit = _netProfit)));
  }
}
