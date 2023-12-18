import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  // Placeholder data (replace with actual data)
  double totalRemainingStockValue = 1500.0;
  double totalStockValue = 5000.0;
  List<Map<String, dynamic>> stockItems = [
    {"name": "Beans", "quantity": 10},
    {"name": "Peanut Butter", "quantity": 100},
    // Add more stock items as needed
  ];
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPop: () {
          _routerService.pop();
        },
        title: 'StockLevel',
        showActionButton: false,
        onActionButtonClicked: () async {
          _routerService.pop();
        },
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show current stock value as text
            ListTile(
              title: Text(
                "Current Stock Value",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${totalStockValue.toStringAsFixed(2)} RWF",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),

            SizedBox(height: 16.0),

            // Show list of stock items with a horizontal bar chart
            Container(
              height: 200.0,
              child: charts.BarChart(
                [
                  charts.Series(
                    id: 'StockItems',
                    data: stockItems,
                    domainFn: (datum, _) => datum['name'],
                    measureFn: (datum, _) => datum['quantity'],
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    labelAccessorFn: (datum, _) =>
                        '${datum['name']}: ${datum['quantity']}',
                  ),
                ],
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
