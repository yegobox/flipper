import 'package:flipper_dashboard/ReportCard.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Reports extends StatefulHookConsumerWidget {
  const Reports({super.key});

  @override
  ReportsState createState() => ReportsState();
}

class ReportsState extends ConsumerState<Reports>
    with SingleTickerProviderStateMixin {
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
    final stockValue =
        ref.watch(stocValueProvider(ProxyService.box.getBranchId()!));
    final soldStock =
        ref.watch(soldStockValueProvider(ProxyService.box.getBranchId()!));

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          closeButton: CLOSEBUTTON.WIDGET,
          isDividerVisible: false,
          customLeadingWidget: back.BackButton(),
          onPop: () async {},
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(width: 16.0),
              Flexible(
                child: ReportCard(
                  cardName: "Stock Value",
                  wordingA: "Current Stock",
                  wordingB: "Sold",
                  valueA: stockValue.asData?.value ?? 0,
                  valueB: soldStock.asData?.value ?? 0,
                  description: "Stock Performance",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
