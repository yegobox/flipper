import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/ui/reports/report_view.dart';
import 'package:flipper/ui/reports/tabs.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/report.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

//todo: get current focused tab then know which date filter to apply
//i.e if 1D then look for today's date this year
class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  double tabLength = 50.0;
  TabController _tabReportController;
  final _navigationService = ProxyService.nav;

  double _grossProfit;

  double _netProfit;

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabReportController = TabController(vsync: this, length: 5);
    _tabReportController.addListener(() {
      // print(_tabController.index);
    });
    _grossProfit = 0;
    _netProfit = 0;
    //on init assume we are on 1D tab focus load Today's report.
    // get orderDetail subTotal sum them up for gross profit
    //net profit: take the gross profit - (supplier price of this products id sums)
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    asyncMethod();
  }

  Future asyncMethod() async {
    final store = StoreProvider.of<AppState>(context);
    double cost = 0;
    // FIXME:
    // List<OrderDetailTableData> report =
    //     await store.state.database.stockDao.getReport(dateFilter: '1D');

    // for (var i = 0; i < report.length; i++) {
    //   //load retail and sum them
    //   if (report[i].productName != 'custom-product') {
    //     //i.e custom sell does not have stock at hand.
    //     StockTableData stock = await store.state.database.stockDao
    //         .getStockByVariantId(
    //             variantId: report[i].variationId,
    //             branchId: store.state.branch.id);

    //     cost += stock.retailPrice;
    //   }
    // }

    // _grossProfit = report.fold(0, (a, b) => a + (b.subTotal));
    _netProfit = _grossProfit - cost;

    store.dispatch(ReportAction(
        report: Report((report) => report
          ..grossProfit = _grossProfit
          ..netProfit = _netProfit)));
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

    asyncMethod();
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: CommonAppBar(
                onPop: () {
                  Routing.navigator.pop();
                },
                title: 'Report',
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () async {},
                actionButtonName: 'save',
                action: Container(
                  width: double.infinity,
                  child: Wrap(
                    children: <Widget>[
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            _navigationService.navigateTo(Routing.dateScreen);
                          },
                          child: Text('From Date'),
                        ),
                      ),
                      Tabs(
                        tabLength: tabLength,
                        tabController: _tabReportController,
                        store: store,
                      )
                    ],
                  ),
                ),
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 146,
              ),
              body: TabBarView(
                controller: _tabReportController,
                children: [
                  // FIXME:
                  // ReportView(
                  //   grossProfit: vm.report?.grossProfit,
                  //   netProfit: vm.report?.netProfit,
                  // ),
                  // ReportView(
                  //   grossProfit: vm.report?.grossProfit,
                  //   netProfit: vm.report?.netProfit,
                  // ),
                  // ReportView(
                  //   grossProfit: vm.report?.grossProfit,
                  //   netProfit: vm.report?.netProfit,
                  // ),
                  // ReportView(
                  //   grossProfit: vm.report?.grossProfit,
                  //   netProfit: vm.report?.netProfit,
                  // ),
                  // ReportView(
                  //   grossProfit: vm.report?.grossProfit,
                  //   netProfit: vm.report?.netProfit,
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
