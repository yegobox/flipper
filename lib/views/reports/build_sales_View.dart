import 'package:expandable/expandable.dart';
import 'package:flipper/data/sales_graph.dart';
import 'package:flipper/routes/router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tabbar/tabbar.dart';

import 'salesReportModel.dart';

class SalesView extends StatelessWidget {
  const SalesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
        builder: (BuildContext context, ReportViewModel model, Widget child) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Sales',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                const Icon(
                  Feather.upload,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                    child: Icon(
                      Feather.trending_up,
                      size: 16.0,
                    )),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: const Color(0xFFF6F6F6),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    model.navigateTo(
                                        path: Routing.calendarView);
                                  },
                                  child: Text(
                                    'Today,${model.date}',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 11.0,
                                            color: Color(0xFF1E96F0),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                              child: Center(
                                child: Text(
                                    'All device, vs same Day Previous Weak',
                                    style: GoogleFonts.lato(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                      TabbarHeader(
                        controller: model.controller,
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        tabs: [
                          // ignore: prefer_const_constructors
                          Tab(
                            text: '1D',
                          ),
                          const Tab(text: '1W'),
                          const Tab(
                            text: '1M',
                          ),
                          const Tab(
                            text: '3M',
                          ),
                          const Tab(
                            text: '1Y',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: TabbarContent(
              controller: model.controller,
              children: <Widget>[
                Container(
                  child: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: [
                        _salesCard(
                            grossSale: '1',
                            averageSale: 4.0,
                            refunds: 1,
                            discount: 4,
                            today: 20,
                            title: 'DAILY GROSS SALES',
                            model: model),
                        _paymentType(
                            total: 34,
                            other: 0.36,
                            fees: 40,
                            net: 102.0,
                            model: model),
                        _topItemMenu(),
                        //NOTES: to be looped when in need
                        _itemDetails(
                            name: 'benz',
                            details: 'buy new benz',
                            cost: 45.0,
                            model: model),
                        //end
                        _categoryMenu(),
                        _categoryDetails(
                            name: 'uncategorized',
                            details: 'Benz new',
                            cost: 4.0,
                            model: model)
                      ],
                    ),
                  )),
                ),
                Container(
                  child: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: [
                        _salesCard(
                            grossSale: '1',
                            averageSale: 4.0,
                            refunds: 1,
                            discount: 4,
                            today: 20,
                            title: 'WEEKLY GROSS SALES',
                            model: model),
                        _paymentType(
                            total: 34,
                            other: 0.36,
                            fees: 40,
                            net: 102.0,
                            model: model),
                        _topItemMenu(),
                        //NOTES: to be looped when in need
                        _itemDetails(
                            name: 'benz',
                            details: 'buy new benz',
                            cost: 45.0,
                            model: model),
                        //end
                        _categoryMenu(),
                        _categoryDetails(
                            name: 'uncategorized',
                            details: 'Benz new',
                            cost: 4.0,
                            model: model)
                      ],
                    ),
                  )),
                ),
                Container(
                  child: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: [
                        _salesCard(
                            grossSale: '1',
                            averageSale: 4.0,
                            refunds: 1,
                            discount: 4,
                            today: 20,
                            title: 'MONTHLY GROSS SALES',
                            model: model),
                        _paymentType(
                            total: 34,
                            other: 0.36,
                            fees: 40,
                            net: 102.0,
                            model: model),
                        _topItemMenu(),
                        //NOTES: to be looped when in need
                        _itemDetails(
                            name: 'benz',
                            details: 'buy new benz',
                            cost: 45.0,
                            model: model),
                        //end
                        _categoryMenu(),
                        _categoryDetails(
                            name: 'uncategorized',
                            details: 'Benz new',
                            cost: 4.0,
                            model: model)
                      ],
                    ),
                  )),
                ),
                Container(
                  child: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: [
                        _salesCard(
                            grossSale: '1',
                            averageSale: 4.0,
                            refunds: 1,
                            discount: 4,
                            today: 20,
                            title: 'SEMESTER GROSS SALES',
                            model: model),
                        _paymentType(
                            total: 34,
                            other: 0.36,
                            fees: 40,
                            net: 102.0,
                            model: model),
                        _topItemMenu(),
                        //NOTES: to be looped when in need
                        _itemDetails(
                            name: 'benz',
                            details: 'buy new benz',
                            cost: 45.0,
                            model: model),
                        //end
                        _categoryMenu(),
                        _categoryDetails(
                            name: 'uncategorized',
                            details: 'Benz new',
                            cost: 4.0,
                            model: model)
                      ],
                    ),
                  )),
                ),
                Container(
                  child: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: [
                        _salesCard(
                            grossSale: '1',
                            averageSale: 4.0,
                            refunds: 1,
                            discount: 4,
                            today: 20,
                            title: 'YEARLY GROSS SALES',
                            model: model),
                        _paymentType(
                            total: 34,
                            other: 0.36,
                            fees: 40,
                            net: 102.0,
                            model: model),
                        _topItemMenu(),
                        //NOTES: to be looped when in need
                        _itemDetails(
                            name: 'benz',
                            details: 'buy new benz',
                            cost: 45.0,
                            model: model),
                        //end
                        _categoryMenu(),
                        _categoryDetails(
                            name: 'uncategorized',
                            details: 'Benz new',
                            cost: 4.0,
                            model: model)
                      ],
                    ),
                  )),
                ),
              ],
            ),
          );
        },
        onModelReady: (ReportViewModel model) {
          //initialization here
        },
        viewModelBuilder: () => ReportViewModel());
  }

// sales  card
  Widget _salesCard(
      {@required String grossSale,
      @required double averageSale,
      @required double refunds,
      @required double discount,
      @required double today,
      @required String title,
      @required ReportViewModel model}) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding:const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Gross Sale',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Net Sales',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Divider(
                color: Colors.grey[300],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(grossSale,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('FRw $averageSale',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.grey[800]))),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Sales',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Average Sale',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('FRw $refunds',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('FRw $discount',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.grey[800]))),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Refunds',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Discount & Camps',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(title,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                 const Expanded(
                      flex: 1,
                      child: Icon(
                        Entypo.dots_three_horizontal,
                        color: Color(0xFF1E96F0),
                      )),
                ],
              ),
             const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Today',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text('Same Day Previous Week',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: Colors.grey[800])))),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('FRw $today',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            textStyle: const TextStyle(
                                fontSize: 15.0,
                                color:  Color(0xFF1E96F0)))),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text('',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color(0xFF1E96F0))))),
                ],
              ),
              Container(
                  child: SfCartesianChart(series: <ChartSeries>[
                // Renders line chart
                LineSeries<SalesData, double>(
                    dataSource: chartData,
                    xValueMapper: (SalesData sales, _) => sales.times,
                    yValueMapper: (SalesData sales, _) => sales.sales),
              ]))
            ],
          ),
        ),
      ),
    );
  }
// payment type

  Widget _paymentType(
      {@required double total,
      @required double other,
      @required double fees,
      @required double net,
      @required ReportViewModel model}) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text('SALES BY PAYMENT TYPES',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Total Collected',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('FRw $total',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey[800]))),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Divider(
                color: Colors.grey[300],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Other',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14.0, color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('FRw $other',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Divider(
                color: Colors.grey[300],
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Fees',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14.0, color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('FRw$fees',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14.0, color: Colors.grey[800]))),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Net Total',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('FRw $net',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey[800]))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TOP item Widget goes here!
  // start with Menu
  Widget _topItemMenu() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text('TOP ITEMS',
                      style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                              color: Colors.grey[700]))),
                ),
                const Expanded(
                    flex: 1,
                    child: Icon(
                      Entypo.dots_three_horizontal,
                      color: Color(0xFF1E96F0),
                    )),
              ],
            ),
            // Adding Gross button here
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: null,
                      elevation: 0.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: const Color(0xFF2C2C32),
                      child: Text('GROSS',
                          style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    )),
                Expanded(
                    flex: 1,
                    child: OutlineButton(
                      onPressed: null,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.black,
                      child: Text('Count',
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold))),
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }

//  Items details widget here!
  Widget _itemDetails(
      {@required String name,
      @required String details,
      @required double cost,
      @required ReportViewModel model}) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Divider(
              color: Colors.grey[300],
            ),
            ExpandablePanel(
              iconPlacement: ExpandablePanelIconPlacement.left,
              header: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(name,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('FRw $cost',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                  ],
                ),
              ),
              expanded: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(details,
                                softWrap: true,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.grey[800]))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('FRw $cost',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.grey[800]))),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                    ],
                  )),
              tapHeaderToExpand: true,
            ),
            // Adding Gross button here
          ]),
        ),
      ),
    );
  }

  // Category widget
  Widget _categoryMenu() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text('TOP CATEGORIES',
                      style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                              color: Colors.grey[700]))),
                ),
                const Expanded(
                    flex: 1,
                    child: Icon(
                      Entypo.dots_three_horizontal,
                      color: Color(0xFF1E96F0),
                    )),
              ],
            ),
            // Adding Gross button here
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: null,
                      elevation: 0.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: const Color(0xFF2C2C32),
                      child: Text('GROSS',
                          style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    )),
                Expanded(
                    flex: 1,
                    child: OutlineButton(
                      onPressed: null,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.black,
                      child: Text('Count',
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold))),
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }

// category details
//  Items details widget here!
  Widget _categoryDetails(
      {@required String name,
      @required String details,
      @required double cost,
      @required ReportViewModel model}) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Divider(
              color: Colors.grey[300],
            ),
            ExpandablePanel(
              iconPlacement: ExpandablePanelIconPlacement.left,
              header: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(name,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('FRw $cost',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.grey[800]))),
                    ),
                  ],
                ),
              ),
              expanded: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(details,
                                softWrap: true,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.grey[800]))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('FRw $cost',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.grey[800]))),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                    ],
                  )),
             
            ),
            // Adding Gross button here
          ]),
        ),
      ),
    );
  }
}
