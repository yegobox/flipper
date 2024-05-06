import 'package:flipper_dashboard/ReportCard.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        closeButton: CLOSEBUTTON.WIDGET,
        isDividerVisible: false,
        customLeadingWidget: back.BackButton(),
        onPop: () async {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sales Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: ReportCard(
                    cardName: "Stock Value",
                    wordingA: "Current Stock",
                    wordingB: "Sold",
                    valueA: 500000,
                    valueB: 1500,
                    description: "Stock Performance",
                  ),
                ),
                // Flexible(
                //   child: ReportCard(
                //     cardName: "Stock Value",
                //     wordingA: "Current Stock",
                //     wordingB: "Sold",
                //     valueA: 1200,
                //     valueB: 1800,
                //   ),
                // ),
              ],
            ),
            // Add more widgets here for additional dashboard components
          ],
        ),
      ),
    );
  }
}
