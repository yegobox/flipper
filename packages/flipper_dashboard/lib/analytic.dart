import 'package:ant_icons/ant_icons.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flipper_models/view_models/analytic_viewmodel.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

import 'analytics/lineF.dart';

class Analytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentWidth = MediaQuery.of(context).size.width;
    var extraLargeScreenGrid = currentWidth > 1536;
    var tabScreenGrid = currentWidth > 769;

    return Scaffold(
      appBar: CustomAppBar(
        onPop: () async {
          ProxyService.nav.back();
        },
        title: 'Analytics',
        disableButton: false,
        showActionButton: false,
        onPressedCallback: () async {},
        rightActionButtonName: 'Save',
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 50,
      ),
      body: ViewModelBuilder<AnalyticViewModel>.reactive(
        viewModelBuilder: () => AnalyticViewModel(),
        onModelReady: (model) {
          model.analytic.countLifeTimeCustomers();
          model.analytic.countOrdersByThisWeek();
        },
        builder: (context, model, child) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 2.w,
                  top: 1.h,
                  right: 2.w,
                  bottom: 2.h,
                ),
                child: GridView.count(
                  crossAxisCount: extraLargeScreenGrid
                      ? 4
                      : tabScreenGrid
                          ? 2
                          : 1,
                  childAspectRatio: 3.5,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 20.0,
                  padding: EdgeInsets.all(02.0),
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Container(
                        color: Colors.blue[300],
                        height: 120.h,
                        padding: EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: Text(
                                          'Revenue',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: Text(
                                          '\RWF' +
                                              model.analytic.revenue.toString(),
                                          style: TextStyle(
                                            fontSize: 40.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 120.w,
                              height: 120.h,
                              child: Icon(
                                AntIcons.dollar,
                                size: 50.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        color: Colors.red[300],
                        height: 120.h,
                        padding: EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: Text(
                                          'Total Orders',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: Text(
                                          model.analytic.orders.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 40.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 120.w,
                              height: 120.h,
                              child: Icon(
                                FeatherIcons.tag,
                                size: 50.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        color: Colors.indigo[300],
                        height: 120.h,
                        padding: EdgeInsets.all(0.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 01.0),
                            borderRadius: BorderRadius.circular(03.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 15.w),
                                          child: Text(
                                            'Customers',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 15.w),
                                          child: Text(
                                            model.analytic.customers.toString(),
                                            style: TextStyle(
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 120.w,
                                height: 120.h,
                                child: Icon(
                                  Ionicons.people_outline,
                                  size: 50.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: LineF(),
              ),
            ],
          );
        },
      ),
    );
  }
}
